import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum DrawTool {
  pencil,
  spray,
}

/// Как PNG-контур вписан в область холста.
enum OutlineImageFit {
  /// Пропорции сохранены, возможны поля по краям.
  contain,

  /// На всю область, возможно искажение пропорций («растянуть»).
  fill,
}

extension OutlineImageFitVisual on OutlineImageFit {
  BoxFit get boxFit => switch (this) {
        OutlineImageFit.contain => BoxFit.contain,
        OutlineImageFit.fill => BoxFit.fill,
      };

  String get shortLabel => switch (this) {
        OutlineImageFit.contain => 'Вписать',
        OutlineImageFit.fill => 'Растянуть',
      };

  IconData get icon => switch (this) {
        OutlineImageFit.contain => Icons.fit_screen_outlined,
        OutlineImageFit.fill => Icons.open_in_full_outlined,
      };

  OutlineImageFit get next => switch (this) {
        OutlineImageFit.contain => OutlineImageFit.fill,
        OutlineImageFit.fill => OutlineImageFit.contain,
      };
}

class SprayParticle {
  const SprayParticle(this.offset, this.radius, this.alpha);
  final Offset offset;
  final double radius;
  final double alpha;
}

class Stroke {
  Stroke(this.color, this.tool, {required this.lineWidth});

  final Color color;
  final DrawTool tool;
  /// Толщина линии на момент рисования (карандаш). Для баллончика не используется.
  final double lineWidth;
  final List<Offset> linePoints = <Offset>[];
  final List<SprayParticle> particles = <SprayParticle>[];
}

void _paintStrokeOnCanvas(Canvas canvas, Stroke stroke) {
  if (stroke.tool == DrawTool.spray) {
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false;
    for (final p in stroke.particles) {
      dotPaint.color = stroke.color.withValues(alpha: p.alpha.clamp(0.02, 1.0));
      dotPaint.isAntiAlias = p.radius >= 1.75;
      canvas.drawCircle(p.offset, p.radius, dotPaint);
    }
    return;
  }

  if (stroke.linePoints.isEmpty) return;
  final lineWidth = stroke.lineWidth;
  final paint = Paint()
    ..color = stroke.color
    ..strokeWidth = lineWidth
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  if (stroke.linePoints.length == 1) {
    final dot = Paint()
      ..color = stroke.color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(stroke.linePoints.single, lineWidth * 0.6, dot);
    return;
  }

  final path = Path()..moveTo(stroke.linePoints.first.dx, stroke.linePoints.first.dy);
  for (var i = 1; i < stroke.linePoints.length; i++) {
    path.lineTo(stroke.linePoints[i].dx, stroke.linePoints[i].dy);
  }
  canvas.drawPath(path, paint);
}

class DrawingPainter extends CustomPainter {
  DrawingPainter(
    this.strokes, {
    required this.repaintTick,
    this.drawBackground = false,
    this.committedImage,
    this.committedStrokeCount = 0,
  });

  final List<Stroke> strokes;
  final int repaintTick;
  final bool drawBackground;
  /// Растер завершённых штрихов — один drawImage вместо тысяч примитивов.
  final ui.Image? committedImage;
  final int committedStrokeCount;

  @override
  void paint(Canvas canvas, Size size) {
    if (drawBackground) {
      final bg = Paint()..color = Colors.white;
      canvas.drawRect(Offset.zero & size, bg);
    }

    if (committedImage != null) {
      final src = Rect.fromLTWH(
        0,
        0,
        committedImage!.width.toDouble(),
        committedImage!.height.toDouble(),
      );
      canvas.drawImageRect(
        committedImage!,
        src,
        Offset.zero & size,
        Paint()..filterQuality = FilterQuality.low,
      );
    }

    for (var i = committedStrokeCount; i < strokes.length; i++) {
      _paintStrokeOnCanvas(canvas, strokes[i]);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) =>
      oldDelegate.repaintTick != repaintTick ||
      oldDelegate.drawBackground != drawBackground ||
      oldDelegate.committedImage != committedImage ||
      oldDelegate.committedStrokeCount != committedStrokeCount;
}

/// Холст: жесты и штрихи изолированы от родителя — меньше лишних перерисовок.
class PaintingViewport extends StatefulWidget {
  const PaintingViewport({
    super.key,
    required this.backgroundBytes,
    required this.loadingOutline,
    required this.color,
    required this.tool,
    required this.pencilWidth,
    required this.spraySpread,
    required this.onHasStrokesChanged,
    this.outlineImageFit = OutlineImageFit.contain,
  });

  final Uint8List? backgroundBytes;
  final bool loadingOutline;
  final Color color;
  final DrawTool tool;
  final double pencilWidth;
  final double spraySpread;
  final ValueChanged<bool> onHasStrokesChanged;
  final OutlineImageFit outlineImageFit;

  @override
  State<PaintingViewport> createState() => PaintingViewportState();
}

class PaintingViewportState extends State<PaintingViewport> {
  /// Не копим сотни перерисовок за один кадр — один слой на кадр.
  bool _strokeRepaintPending = false;
  int _paintGen = 0;
  /// Пропускаем почти повторяющиеся точки — меньше вершин в Path.
  static const double _pencilMinSampleGap = 1.12;

  final math.Random _rand = math.Random();
  final List<Stroke> _strokes = <Stroke>[];
  Stroke? _current;
  int _repaintTick = 0;
  /// Перерисовка только слоя штрихов — без разборки всего Stack (фон PNG дорогой).
  final ValueNotifier<int> _strokeLayerTick = ValueNotifier<int>(0);
  DateTime? _lastSprayTime;
  Offset? _lastSprayPos;

  /// Растер завершённых штрихов (Picture лишь повторяла команды — не ускоряла).
  ui.Image? _committedImage;
  int _committedStrokeCount = 0;
  Size _canvasSize = Size.zero;
  double _lastDpr = 1.0;
  /// Очередь растеризации — внутри один проход «дожимает» все штрихи до актуального конца.
  Future<void> _bakeQueue = Future<void>.value();

  @override
  void dispose() {
    _committedImage?.dispose();
    _strokeLayerTick.dispose();
    super.dispose();
  }

  void _resetCommittedLayer() {
    _committedImage?.dispose();
    _committedImage = null;
    _committedStrokeCount = 0;
  }

  /// Растер в один проход: пока toImage не успел, все новые штрихи оставались векторами → тормозило.
  void _scheduleBakeCommittedStroke() {
    final gen = _paintGen;
    _bakeQueue = _bakeQueue.then((_) => _drainCommittedBakeQueue(gen));
  }

  /// Сколько последних штрихов ещё рисуем с жеста (нельзя запекать в bitmap).
  int get _openStrokeTailCount => _current != null ? 1 : 0;

  /// Штрихи с индекса 0..(length - tail - 1) завершены и могут быть в растре.
  int get _completeStrokeCount =>
      (_strokes.length - _openStrokeTailCount).clamp(0, _strokes.length);

  Future<void> _drainCommittedBakeQueue(int gen) async {
    while (mounted && gen == _paintGen) {
      final target = _completeStrokeCount;
      if (_committedStrokeCount >= target) break;

      await _rasterizeStrokeRange(
        gen,
        _committedStrokeCount,
        target,
      );
    }
  }

  /// Один full-screen toImage для диапазона [start, exclusiveEnd) — не цепочка по штриху.
  Future<void> _rasterizeStrokeRange(
    int gen,
    int start,
    int exclusiveEnd,
  ) async {
    if (!mounted || gen != _paintGen) return;
    final size = _canvasSize;
    final dpr = _lastDpr;
    if (size.isEmpty) return;

    var end = exclusiveEnd.clamp(0, _strokes.length);
    if (start >= end) return;

    final w = (size.width * dpr).round().clamp(1, 8192);
    final h = (size.height * dpr).round().clamp(1, 8192);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(dpr);

    if (_committedImage != null) {
      final src = Rect.fromLTWH(
        0,
        0,
        _committedImage!.width.toDouble(),
        _committedImage!.height.toDouble(),
      );
      canvas.drawImageRect(
        _committedImage!,
        src,
        Offset.zero & size,
        Paint()..filterQuality = FilterQuality.low,
      );
    }

    for (var i = start; i < end; i++) {
      _paintStrokeOnCanvas(canvas, _strokes[i]);
    }

    final picture = recorder.endRecording();
    late final ui.Image newImage;
    try {
      newImage = await picture.toImage(w, h);
    } finally {
      picture.dispose();
    }

    if (!mounted) {
      newImage.dispose();
      return;
    }
    if (gen != _paintGen) {
      newImage.dispose();
      return;
    }

    if (_committedStrokeCount != start || end > _strokes.length) {
      newImage.dispose();
      return;
    }

    final prev = _committedImage;
    _committedImage = newImage;
    _committedStrokeCount = end;
    prev?.dispose();
    _repaintTick++;
    _strokeLayerTick.value++;
  }

  void clearStrokes() {
    _paintGen++;
    _strokeRepaintPending = false;
    _bakeQueue = Future<void>.value();
    _strokes.clear();
    _current = null;
    _resetCommittedLayer();
    _repaintTick++;
    _strokeLayerTick.value++;
    setState(() {});
    widget.onHasStrokesChanged(false);
  }

  void _appendPencilPoint(Offset p) {
    final stroke = _current;
    if (stroke == null || stroke.tool != DrawTool.pencil) return;
    final pts = stroke.linePoints;
    const maxPencilPoints = 8000;
    if (pts.isNotEmpty && pts.length >= maxPencilPoints) return;
    if (pts.isEmpty || (p - pts.last).distance >= _pencilMinSampleGap) {
      pts.add(p);
    }
  }

  /// Одно обновление слоя на кадр (SchedulerBinding), без лишних CustomPaint.
  void _requestStrokeLayerPaint() {
    if (_strokeRepaintPending) return;
    _strokeRepaintPending = true;
    final gen = _paintGen;
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _strokeRepaintPending = false;
      if (gen != _paintGen) return;
      _repaintTick++;
      _strokeLayerTick.value++;
      widget.onHasStrokesChanged(_strokes.isNotEmpty);
    });
  }

  void _sprayAt(
    Offset center,
    double areaFactor, {
    required bool hasBackground,
  }) {
    final s = _current;
    if (s == null || s.tool != DrawTool.spray) return;
    const maxParticlesPerStroke = 11000;
    if (s.particles.length >= maxParticlesPerStroke) return;
    final spread = widget.spraySpread;
    // С фоном композитит две полноэкранные текстуры — уменьшаем «порцию» частиц за событие.
    final bgMul = hasBackground ? 0.76 : 1.0;
    var count = (7 + widget.spraySpread * 0.95) * areaFactor * bgMul;
    final cap = hasBackground ? 28 : 38;
    count = count.round().clamp(4, cap).toDouble();
    final n = count.round();
    for (var i = 0; i < n; i++) {
      final theta = _rand.nextDouble() * 2 * math.pi;
      final r = spread * math.sqrt(_rand.nextDouble());
      final dx = r * math.cos(theta);
      final dy = r * math.sin(theta);
      final dotR = 0.35 + _rand.nextDouble() * (4 + spread * 0.22);
      final alpha = 0.06 + _rand.nextDouble() * 0.14;
      s.particles.add(
        SprayParticle(Offset(center.dx + dx, center.dy + dy), dotR, alpha),
      );
    }
  }

  /// На больших экранах PointerMove сыплет сотнями событий — ограничиваем баллончик.
  bool _shouldSprayOnMove(Offset pos, double spread, {required bool hasBackground}) {
    final lastT = _lastSprayTime;
    final lastP = _lastSprayPos;
    if (lastT == null || lastP == null) return true;
    final dtMs = DateTime.now().difference(lastT).inMilliseconds;
    final dist = (pos - lastP).distance;
    var minGap = 2.9 + spread * 0.075;
    var minMs = 17;
    if (hasBackground) {
      minGap += 0.55;
      minMs = 19;
    }
    if (dtMs < minMs && dist < minGap) return false;
    return true;
  }

  bool _layoutSizeChanged(Size a, Size b) {
    if (a.isEmpty || b.isEmpty) return a != b;
    return (a.width - b.width).abs() > 0.5 ||
        (a.height - b.height).abs() > 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final hasBg = widget.backgroundBytes != null;
    _lastDpr = MediaQuery.devicePixelRatioOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        // Иначе дрожание constraints сбрасывает Picture-кэш и снова гоняет все частицы.
        if (_canvasSize != Size.zero && _layoutSizeChanged(_canvasSize, size)) {
          _paintGen++;
          _resetCommittedLayer();
          _repaintTick++;
          _strokeLayerTick.value++;
        }
        _canvasSize = size;
        final area = size.width * size.height;
        const refArea = 420000.0;
        final areaFactor = (refArea / math.max(1, area)).clamp(0.45, 1.0);

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) {
            _lastSprayTime = null;
            _lastSprayPos = null;
            if (widget.tool == DrawTool.pencil) {
              _current = Stroke(
                widget.color,
                DrawTool.pencil,
                lineWidth: widget.pencilWidth,
              )..linePoints.add(e.localPosition);
            } else {
              _current = Stroke(widget.color, DrawTool.spray, lineWidth: 0);
              _sprayAt(e.localPosition, areaFactor, hasBackground: hasBg);
              _lastSprayTime = DateTime.now();
              _lastSprayPos = e.localPosition;
            }
            _strokes.add(_current!);
            _requestStrokeLayerPaint();
          },
          onPointerMove: (e) {
            if (_current == null) return;
            if (widget.tool == DrawTool.pencil) {
              _appendPencilPoint(e.localPosition);
              _requestStrokeLayerPaint();
              return;
            }
            if (!_shouldSprayOnMove(
                  e.localPosition,
                  widget.spraySpread,
                  hasBackground: hasBg,
                )) {
              return;
            }
            _sprayAt(e.localPosition, areaFactor, hasBackground: hasBg);
            _lastSprayTime = DateTime.now();
            _lastSprayPos = e.localPosition;
            _requestStrokeLayerPaint();
          },
          onPointerUp: (e) {
            if (_current != null && widget.tool == DrawTool.pencil) {
              final pts = _current!.linePoints;
              if (pts.isNotEmpty &&
                  (e.localPosition - pts.last).distance >= 0.35) {
                pts.add(e.localPosition);
              }
            }
            if (_current != null) {
              _scheduleBakeCommittedStroke();
            }
            _current = null;
          },
          onPointerCancel: (_) {
            if (_current == null) return;
            _paintGen++;
            if (_strokes.isNotEmpty) {
              _strokes.removeLast();
            }
            _current = null;
            _repaintTick++;
            _strokeLayerTick.value++;
            widget.onHasStrokesChanged(_strokes.isNotEmpty);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Colors.white),
              RepaintBoundary(
                child: ListenableBuilder(
                  listenable: _strokeLayerTick,
                  builder: (context, _) {
                    return CustomPaint(
                      size: size,
                      painter: DrawingPainter(
                        _strokes,
                        repaintTick: _repaintTick,
                        drawBackground: !hasBg,
                        committedImage: _committedImage,
                        committedStrokeCount: _committedStrokeCount,
                      ),
                    );
                  },
                ),
              ),
              if (hasBg)
                RepaintBoundary(
                  child: IgnorePointer(
                    child: LayoutBuilder(
                      builder: (context, innerConstraints) {
                        final dpr =
                            MediaQuery.devicePixelRatioOf(context);
                        final cw = (innerConstraints.maxWidth * dpr)
                            .round()
                            .clamp(256, 1536);
                        final ch = (innerConstraints.maxHeight * dpr)
                            .round()
                            .clamp(256, 1536);
                        return SizedBox(
                          width: innerConstraints.maxWidth,
                          height: innerConstraints.maxHeight,
                          child: Image.memory(
                            widget.backgroundBytes!,
                            fit: widget.outlineImageFit.boxFit,
                            gaplessPlayback: true,
                            filterQuality: FilterQuality.low,
                            cacheWidth: cw,
                            cacheHeight: ch,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (widget.loadingOutline)
                ColoredBox(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.65),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Строим контуры…'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
