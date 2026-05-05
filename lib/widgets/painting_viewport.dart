import 'dart:math' as math;
import 'dart:typed_data';

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

class DrawingPainter extends CustomPainter {
  DrawingPainter(
    this.strokes, {
    required this.repaintTick,
    this.drawBackground = false,
  });

  final List<Stroke> strokes;
  final int repaintTick;
  final bool drawBackground;

  @override
  void paint(Canvas canvas, Size size) {
    if (drawBackground) {
      final bg = Paint()..color = Colors.white;
      canvas.drawRect(Offset.zero & size, bg);
    }

    for (final stroke in strokes) {
      if (stroke.tool == DrawTool.spray) {
        final dotPaint = Paint()
          ..style = PaintingStyle.fill
          ..isAntiAlias = false;
        for (final p in stroke.particles) {
          dotPaint.color =
              stroke.color.withValues(alpha: p.alpha.clamp(0.02, 1.0));
          // Мелкие капли без сглаживания — дешевле на слабом GPU.
          dotPaint.isAntiAlias = p.radius >= 1.75;
          canvas.drawCircle(p.offset, p.radius, dotPaint);
        }
        continue;
      }

      if (stroke.linePoints.isEmpty) continue;
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
        continue;
      }

      final path = Path()..moveTo(stroke.linePoints.first.dx, stroke.linePoints.first.dy);
      for (var i = 1; i < stroke.linePoints.length; i++) {
        path.lineTo(stroke.linePoints[i].dx, stroke.linePoints[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) =>
      oldDelegate.repaintTick != repaintTick ||
      oldDelegate.drawBackground != drawBackground;
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

  @override
  void dispose() {
    _strokeLayerTick.dispose();
    super.dispose();
  }

  void clearStrokes() {
    _paintGen++;
    _strokeRepaintPending = false;
    _strokes.clear();
    _current = null;
    _repaintTick++;
    _strokeLayerTick.value++;
    setState(() {});
    widget.onHasStrokesChanged(false);
  }

  void _appendPencilPoint(Offset p) {
    final stroke = _current;
    if (stroke == null || stroke.tool != DrawTool.pencil) return;
    final pts = stroke.linePoints;
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

  void _sprayAt(Offset center, double areaFactor) {
    final s = _current;
    if (s == null || s.tool != DrawTool.spray) return;
    final spread = widget.spraySpread;
    // При большой ширине баллончика — чуть меньше точек за раз (компенсируется частотой жеста).
    var count = (7 + widget.spraySpread * 0.95) * areaFactor;
    count = count.round().clamp(4, 38).toDouble();
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
  bool _shouldSprayOnMove(Offset pos, double spread) {
    final lastT = _lastSprayTime;
    final lastP = _lastSprayPos;
    if (lastT == null || lastP == null) return true;
    final dtMs = DateTime.now().difference(lastT).inMilliseconds;
    final dist = (pos - lastP).distance;
    final minGap = 2.9 + spread * 0.075;
    if (dtMs < 17 && dist < minGap) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final hasBg = widget.backgroundBytes != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
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
              _sprayAt(e.localPosition, areaFactor);
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
            if (!_shouldSprayOnMove(e.localPosition, widget.spraySpread)) {
              return;
            }
            _sprayAt(e.localPosition, areaFactor);
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
              _requestStrokeLayerPaint();
            }
            _current = null;
          },
          onPointerCancel: (_) {
            _current = null;
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
