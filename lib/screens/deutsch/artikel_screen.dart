import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/der_die_das_data.dart';
import '../../data/der_die_das_theory.dart';
import '../../services/german_word_tts.dart';
import '../../utils/artikel_stats_feedback.dart';

/// Теория + упражнение: артикль der / die / das для существительного.
class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen>
    with SingleTickerProviderStateMixin {
  static const _optLabels = ['der', 'die', 'das'];

  late TabController _tabs;
  late List<DerDieDasQuestion> _items;
  late int _zielAnzahl;
  final Random _random = Random();
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;

  bool get _atEnd => _items.isEmpty;

  DerDieDasQuestion? get _current => _atEnd ? null : _items.first;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(_onTabChanged);
    _items = List<DerDieDasQuestion>.from(allDerDieDasQuestions())..shuffle(_random);
    _zielAnzahl = _items.length;
  }

  void _onTabChanged() {
    if (_tabs.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTabChanged);
    _tabs.dispose();
    super.dispose();
  }

  void _reshuffle() {
    GermanWordTts.instance.stop();
    setState(() {
      _items = List<DerDieDasQuestion>.from(allDerDieDasQuestions())..shuffle(_random);
      _zielAnzahl = _items.length;
      _picked = null;
      _showResult = false;
      _richtig = 0;
      _falsch = 0;
    });
  }

  void _speakPrompt() {
    final q = _current;
    if (q == null) return;
    final tts = derDieDasPromptForTts(q.prompt);
    GermanWordTts.instance.speak(tts);
  }

  void _speakFullAnswer() {
    final q = _current;
    if (q == null) return;
    GermanWordTts.instance.speak(q.fullAnswer);
  }

  void _pick(int i) {
    if (_showResult || _current == null) return;
    final ok = i == _current!.correctIndex;
    setState(() {
      _picked = i;
      _showResult = true;
      if (ok) {
        _richtig++;
      } else {
        _falsch++;
      }
    });
  }

  void _next() {
    if (!_showResult || _current == null) return;
    GermanWordTts.instance.stop();
    final q = _items.first;
    final wasCorrect = _picked == q.correctIndex;
    setState(() {
      _items.removeAt(0);
      if (!wasCorrect) {
        if (_items.isEmpty) {
          _items.add(q);
        } else {
          final pos = 1 + _random.nextInt(_items.length);
          _items.insert(pos, q);
        }
      }
      _picked = null;
      _showResult = false;
    });
  }

  String _weiterButtonLabel() {
    final q = _items.first;
    if (_items.length == 1 && _showResult && _picked == q.correctIndex) {
      return 'Fertig';
    }
    return 'Weiter (noch ${_items.length})';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onUebungen = _tabs.index == 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel — der / die / das'),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            const Tab(text: 'Теория'),
            Tab(text: 'Übungen ($_zielAnzahl)'),
          ],
        ),
        actions: [
          if (onUebungen)
            IconButton(
              tooltip: 'Neue Reihenfolge',
              onPressed: _reshuffle,
              icon: const Icon(Icons.shuffle_rounded),
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildTheoryTab(context),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: _atEnd ? _buildDone(context) : _buildQuestion(context, scheme),
            ),
          ),
        ],
      ),
      bottomNavigationBar: onUebungen && !_atEnd && _showResult
          ? Material(
              elevation: 6,
              color: scheme.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(_weiterButtonLabel()),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildTheoryTab(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text(
          'der · die · das',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Nominativ (A1): определённый артикль. Вторая вкладка — 150 карточек с переводом и озвучкой.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        for (final sec in kDerDieDasTheorySections) ...[
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              initiallyExpanded: sec.title.startsWith('1.'),
              title: Text(
                sec.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SelectableText(
                      sec.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                            fontFamily: 'monospace',
                            fontFamilyFallback: const ['monospace'],
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDone(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = artikelAntwortProzent(_richtig, _falsch) ?? 0;
    final fb = artikelFeedbackNachProzent(p, ArtikelStatsModul.nominativDerDieDas);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alle $_zielAnzahl Fragen durch',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  artikelStatistikZeileRu(_richtig, _falsch),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  fb.sterne,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  fb.meldung,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Нажмите shuffle на панели, чтобы начать новый проход и обнулить статистику.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, ColorScheme scheme) {
    final q = _current!;
    final correct = _picked == q.correctIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Выберите артикль для слова. Под ним — перевод на русский. '
          'Динамик произносит только немецкое слово, без артикля. '
          'При ошибке карточка вернётся позже в очередь.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.35,
              ),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: (_richtig / _zielAnzahl).clamp(0.0, 1.0),
        ),
        const SizedBox(height: 8),
        Text(
          artikelStatistikZeileRu(_richtig, _falsch),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcher Artikel?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.prompt,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            q.translationRu,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                  height: 1.35,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Wort anhören (ohne Artikel)',
                      onPressed: _speakPrompt,
                      icon: const Icon(Icons.volume_up_rounded),
                    ),
                  ],
                ),
                if (_showResult) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          correct ? 'Richtig ✓' : 'Nicht richtig.',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: correct
                                ? Colors.green.shade700
                                : scheme.error,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _speakFullAnswer,
                        icon: const Icon(Icons.record_voice_over_outlined, size: 20),
                        label: const Text('Mit Artikel'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q.fullAnswer,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Antwort',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _articleTile(
              context: context,
              index: i,
              label: _optLabels[i],
              scheme: scheme,
              selected: _picked == i,
              showResult: _showResult,
              isCorrect: i == q.correctIndex,
              enabled: !_showResult,
              onTap: () => _pick(i),
            ),
          ),
      ],
    );
  }

  Widget _articleTile({
    required BuildContext context,
    required int index,
    required String label,
    required ColorScheme scheme,
    required bool selected,
    required bool showResult,
    required bool isCorrect,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    Color? border;
    Color? bg;
    if (showResult) {
      if (isCorrect) {
        border = Colors.green.shade600;
        bg = Colors.green.shade50;
      } else if (selected && !isCorrect) {
        border = scheme.error;
        bg = scheme.errorContainer.withValues(alpha: 0.35);
      }
    } else if (selected) {
      border = scheme.primary;
      bg = scheme.primaryContainer.withValues(alpha: 0.5);
    }

    return Material(
      color: bg ?? scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: border ?? scheme.outlineVariant,
              width: border != null ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '${String.fromCharCode(65 + index)})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
