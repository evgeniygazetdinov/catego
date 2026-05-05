import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../data/hoeren_glossary.dart';
import '../services/german_word_tts.dart';
import '../services/hoeren_online_translate.dart';
import '../utils/utf16_sanitize.dart';

/// Hörtext: отдельные слова с подчёркиванием; по нажатию — перевод снизу.
class TappableHortext extends StatefulWidget {
  const TappableHortext({
    super.key,
    required this.text,
    this.style,
    this.wordHints = const {},
  });

  final String text;
  final TextStyle? style;
  final Map<String, String> wordHints;

  @override
  State<TappableHortext> createState() => _TappableHortextState();
}

sealed class _Tok {
  const _Tok(this.raw);
  final String raw;
}

final class _TokWord extends _Tok {
  const _TokWord(super.raw);
}

final class _TokOther extends _Tok {
  const _TokOther(super.raw);
}

List<_Tok> _tokenizeHortext(String text) {
  final pattern = RegExp(
    r"\s+|\d+:\d+|\d+[.,]\d+|[A-Za-zÄÖÜäöüß]+(?:[-'][A-Za-zÄÖÜäöüß]+)*|\d+|[^A-Za-zÄÖÜäöüß0-9\s]",
  );
  return pattern
      .allMatches(text)
      .map((m) {
        final s = m.group(0)!;
        if (RegExp(r'^\s+$').hasMatch(s)) return _TokOther(s);
        if (RegExp(r'^\d+:\d+$').hasMatch(s)) return _TokWord(s);
        if (RegExp(r'^\d+[.,]\d+$').hasMatch(s)) return _TokWord(s);
        if (RegExp(r'^\d+$').hasMatch(s)) return _TokWord(s);
        if (RegExp(r'^[A-Za-zÄÖÜäöüß]').hasMatch(s)) return _TokWord(s);
        return _TokOther(s);
      })
      .toList();
}

/// Регекс для «прочего» режет по одному UTF-16 коду — эмодзи (суррогатная пара)
/// превращается в два токена с половинками; SkParagraph их не принимает.
List<_Tok> _mergeSurrogatePairTokens(List<_Tok> tokens) {
  var list = List<_Tok>.from(tokens);
  var changed = true;
  while (changed) {
    changed = false;
    final next = <_Tok>[];
    for (var i = 0; i < list.length; i++) {
      if (i + 1 < list.length) {
        final a = list[i].raw;
        final b = list[i + 1].raw;
        if (a.length == 1 && b.length == 1) {
          final u = a.codeUnitAt(0);
          final u2 = b.codeUnitAt(0);
          if (u >= 0xD800 &&
              u <= 0xDBFF &&
              u2 >= 0xDC00 &&
              u2 <= 0xDFFF) {
            final merged = String.fromCharCodes([u, u2]);
            final bothWord = list[i] is _TokWord && list[i + 1] is _TokWord;
            next.add(bothWord ? _TokWord(merged) : _TokOther(merged));
            i++;
            changed = true;
            continue;
          }
        }
      }
      next.add(list[i]);
    }
    list = next;
  }
  return list;
}

class _TappableHortextState extends State<TappableHortext> {
  late List<_Tok> _tokens;
  List<TapGestureRecognizer?> _recognizers = [];

  @override
  void initState() {
    super.initState();
    _bindTokens();
  }

  @override
  void didUpdateWidget(TappableHortext oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        !mapEquals(oldWidget.wordHints, widget.wordHints)) {
      _disposeRecognizers();
      _bindTokens();
    }
  }

  void _bindTokens() {
    _tokens = _mergeSurrogatePairTokens(
      _tokenizeHortext(sanitizeWellFormedUtf16(widget.text)),
    );
    _recognizers = List<TapGestureRecognizer?>.generate(_tokens.length, (i) {
      if (_tokens[i] is! _TokWord) return null;
      final surface = _tokens[i].raw;
      return TapGestureRecognizer()
        ..onTap = () => _showTranslation(context, surface);
    });
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r?.dispose();
    }
    _recognizers = [];
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _showTranslation(BuildContext context, String surface) {
    final ru = lookupHoerenWord(surface, wordHints: widget.wordHints);
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) {
        final bottomInset = MediaQuery.viewPaddingOf(ctx).bottom +
            MediaQuery.viewInsetsOf(ctx).bottom;
        return _HoerenWordSheet(
          theme: theme,
          bottomInset: bottomInset,
          surface: surface,
          localRu: ru,
        );
      },
    ).whenComplete(GermanWordTts.instance.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GermanWordTts.instance.speak(surface);
    });
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.style ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.35,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ) ??
        const TextStyle();
    final linkColor = Theme.of(context).colorScheme.primary;

    if (_tokens.isEmpty) {
      return Text('', style: base);
    }

    final children = <InlineSpan>[];
    for (var i = 0; i < _tokens.length; i++) {
      final t = _tokens[i];
      if (t is _TokWord) {
        final safe = sanitizeWellFormedUtf16(t.raw);
        final display = safe.isEmpty ? '\uFFFD' : safe;
        children.add(
          TextSpan(
            text: display,
            style: base.merge(
              TextStyle(
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
                decorationColor: linkColor.withValues(alpha: 0.55),
              ),
            ),
            recognizer: _recognizers[i],
          ),
        );
      } else {
        final safe = sanitizeWellFormedUtf16(t.raw);
        final display = safe.isEmpty ? '\uFFFD' : safe;
        children.add(TextSpan(text: display, style: base));
      }
    }

    return Text.rich(
      TextSpan(children: children),
      textAlign: TextAlign.start,
    );
  }
}

class _HoerenWordSheet extends StatefulWidget {
  const _HoerenWordSheet({
    required this.theme,
    required this.bottomInset,
    required this.surface,
    required this.localRu,
  });

  final ThemeData theme;
  final double bottomInset;
  final String surface;
  final String? localRu;

  @override
  State<_HoerenWordSheet> createState() => _HoerenWordSheetState();
}

class _HoerenWordSheetState extends State<_HoerenWordSheet> {
  bool _loadingRemote = false;
  String? _remoteRu;

  @override
  void initState() {
    super.initState();
    if (widget.localRu == null) {
      _loadingRemote = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchRemote());
    }
  }

  Future<void> _fetchRemote() async {
    final t = await HoerenOnlineTranslate.instance.deToRu(widget.surface);
    if (!mounted) return;
    setState(() {
      _loadingRemote = false;
      _remoteRu = t;
    });
  }

  Future<void> _retryRemote() async {
    setState(() {
      _loadingRemote = true;
      _remoteRu = null;
    });
    await _fetchRemote();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final variant = theme.colorScheme.onSurfaceVariant;

    Widget translationBlock() {
      if (widget.localRu != null) {
        return Text(
          sanitizeWellFormedUtf16(widget.localRu!),
          style: theme.textTheme.bodyLarge,
        );
      }
      if (_loadingRemote) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Запрашиваем перевод…',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        );
      }
      if (_remoteRu != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sanitizeWellFormedUtf16(_remoteRu!),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Перевод из интернета (MyMemory), может быть неточным.',
              style: theme.textTheme.bodySmall?.copyWith(color: variant),
            ),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Не удалось получить перевод (сеть или лимит сервиса). '
            'Можно добавить слово в словарь приложения или в wordHints у задания.',
            style: theme.textTheme.bodyLarge,
          ),
          TextButton.icon(
            onPressed: _retryRemote,
            icon: const Icon(Icons.translate),
            label: const Text('Повторить'),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: widget.bottomInset + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    sanitizeWellFormedUtf16(widget.surface),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Noch einmal hören',
                  onPressed: () => GermanWordTts.instance.speak(widget.surface),
                  icon: const Icon(Icons.volume_up_rounded),
                ),
              ],
            ),
            Text(
              'Произношение при открытии. Нет в словаре — пробуем перевод онлайн.',
              style: theme.textTheme.bodySmall?.copyWith(color: variant),
            ),
            const SizedBox(height: 12),
            translationBlock(),
          ],
        ),
      ),
    );
  }
}
