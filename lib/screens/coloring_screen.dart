import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';

import '../utils/outline_coloring_image.dart';
import '../widgets/painting_viewport.dart';

/// Свободная раскраска поверх контура с фото.
class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  static const _palette = <Color>[
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  final GlobalKey<PaintingViewportState> _canvasKey =
      GlobalKey<PaintingViewportState>();
  final ValueNotifier<bool> _hasStrokesNotifier = ValueNotifier<bool>(false);

  Color _picked = _palette[6];
  Uint8List? _backgroundBytes;
  bool _loadingOutline = false;
  double _pencilWidth = 5;
  double _spraySpread = 14;
  DrawTool _tool = DrawTool.pencil;
  bool _panelExpanded = true;
  OutlineImageFit _outlineFit = OutlineImageFit.contain;

  @override
  void dispose() {
    _hasStrokesNotifier.dispose();
    super.dispose();
  }

  void _clearStrokes() {
    _canvasKey.currentState?.clearStrokes();
  }

  void _clearBackground() {
    setState(() {
      _backgroundBytes = null;
      _outlineFit = OutlineImageFit.contain;
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (!mounted) return;
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Не удалось прочитать файл. Попробуйте другой формат.',
            ),
          ),
        );
      }
      return;
    }

    setState(() => _loadingOutline = true);
    Uint8List? outline;
    try {
      outline = await compute(buildOutlineColoringPng, bytes);
    } catch (_) {
      outline = null;
    }
    if (!mounted) return;
    setState(() => _loadingOutline = false);

    if (outline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Не удалось построить контуры. Попробуйте другое изображение.',
          ),
        ),
      );
      return;
    }
    setState(() {
      _backgroundBytes = outline;
      _outlineFit = OutlineImageFit.contain;
    });
  }

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Толщина карандаша',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Тонко'),
                      Expanded(
                        child: Slider(
                          value: _pencilWidth,
                          min: 2,
                          max: 24,
                          divisions: 22,
                          label: _pencilWidth.round().toString(),
                          onChanged: (v) {
                            setModal(() {});
                            setState(() => _pencilWidth = v);
                          },
                        ),
                      ),
                      const Text('Жирно'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _backgroundBytes == null
                        ? null
                        : () {
                            Navigator.pop(ctx);
                            _clearBackground();
                          },
                    icon: const Icon(Icons.hide_image_outlined),
                    label: const Text('Убрать картинку с фона'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Раскрасим'),
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Настройки',
          onPressed: _openSettings,
        ),
        actions: [
          if (_backgroundBytes != null)
            IconButton(
              icon: Icon(_outlineFit.icon),
              tooltip:
                  'Контур: ${_outlineFit.shortLabel}. Нажмите — сменить режим.',
              onPressed: () =>
                  setState(() => _outlineFit = _outlineFit.next),
            ),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Загрузить картинку'),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _hasStrokesNotifier,
            builder: (context, has, _) {
              return IconButton(
                tooltip: 'Очистить рисунок',
                onPressed: has ? _clearStrokes : null,
                icon: const Icon(Icons.delete_outline),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PaintingViewport(
              key: _canvasKey,
              backgroundBytes: _backgroundBytes,
              loadingOutline: _loadingOutline,
              color: _picked,
              tool: _tool,
              pencilWidth: _pencilWidth,
              spraySpread: _spraySpread,
              outlineImageFit: _outlineFit,
              onHasStrokesChanged: (v) {
                if (_hasStrokesNotifier.value != v) {
                  _hasStrokesNotifier.value = v;
                }
              },
            ),
          ),
          Material(
            elevation: 8,
            color: Theme.of(context).colorScheme.surface,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () =>
                        setState(() => _panelExpanded = !_panelExpanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Icon(
                          _panelExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          size: 28,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Инструмент',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _ToolIconButton(
                                selected: _tool == DrawTool.pencil,
                                icon: Icons.edit_outlined,
                                tooltip: 'Карандаш',
                                onTap: () =>
                                    setState(() => _tool = DrawTool.pencil),
                              ),
                              const SizedBox(width: 10),
                              _ToolIconButton(
                                selected: _tool == DrawTool.spray,
                                icon: Icons.blur_on,
                                tooltip: 'Баллончик',
                                onTap: () =>
                                    setState(() => _tool = DrawTool.spray),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Цвет',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (final c in _palette)
                                GestureDetector(
                                  onTap: () => setState(() => _picked = c),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: c,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: _picked == c ? 3 : 1,
                                        color: _picked == c
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.black26,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (_tool == DrawTool.spray) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.blur_circular,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Пятно',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _spraySpread,
                                    min: 4,
                                    max: 48,
                                    divisions: 22,
                                    label: _spraySpread.round().toString(),
                                    onChanged: (v) =>
                                        setState(() => _spraySpread = v),
                                  ),
                                ),
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    _spraySpread.round().toString(),
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final preset in const [
                                  8.0,
                                  16.0,
                                  24.0,
                                  36.0,
                                ])
                                  FilterChip(
                                    label: Text('${preset.round()}'),
                                    selected:
                                        (_spraySpread - preset).abs() < 1.5,
                                    onSelected: (_) => setState(
                                      () => _spraySpread = preset,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    secondChild: const SizedBox.shrink(),
                    crossFadeState: _panelExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 220),
                    sizeCurve: Curves.easeInOut,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolIconButton extends StatelessWidget {
  const _ToolIconButton({
    required this.selected,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(
              icon,
              size: 28,
              color: selected
                  ? scheme.onPrimaryContainer
                  : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
