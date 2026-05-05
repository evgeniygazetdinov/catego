import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/mixed_quiz_models.dart';
import '../../services/mixed_quiz_repository.dart';

enum _MixedPhase { intro, loading, playing, finished }

String _sessionRecommendationRu(Map<MixedQuizModule, int> wrongByModule) {
  final bad = wrongByModule.entries.where((e) => e.value > 0).toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  if (bad.isEmpty) {
    return 'В этой сессии ошибок по темам нет — отличный результат.';
  }
  final buf = StringBuffer('Рекомендуем повторить:\n');
  for (final e in bad.take(4)) {
    buf.writeln(
      '• ${mixedQuizModuleLabelRu(e.key)} — ошибок в этом проходе: ${e.value}',
    );
  }
  buf.write(
    '\nПри следующем запуске микса чаще будут попадаться вопросы из «слабых» тем и карточек, где вы уже ошибались.',
  );
  return buf.toString();
}

/// 30 случайных вопросов из всех грамматических модулей; статистика и приоритет ошибок.
class MixedQuizScreen extends StatefulWidget {
  const MixedQuizScreen({super.key});

  @override
  State<MixedQuizScreen> createState() => _MixedQuizScreenState();
}

class _MixedQuizScreenState extends State<MixedQuizScreen> {
  final Random _random = Random();
  _MixedPhase _phase = _MixedPhase.intro;
  List<MixedQuizItem>? _queue;
  MixedQuizPersistentState? _cumulative;
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;
  final Map<MixedQuizModule, int> _sessionWrongByModule = {};

  static const int _kTotal = 30;

  bool get _atEnd => _queue != null && _queue!.isEmpty;
  MixedQuizItem? get _current =>
      (_queue != null && _queue!.isNotEmpty) ? _queue!.first : null;

  String _previewLine(MixedQuizItem q) {
    final mid = _picked == null ? '___' : q.options[_picked!];
    final gap = _picked == null ? '___ ' : '$mid ';
    return '${q.beforeGap}$gap${q.afterGap}';
  }

  Future<void> _startSession() async {
    setState(() {
      _phase = _MixedPhase.loading;
      _sessionWrongByModule.clear();
      _picked = null;
      _showResult = false;
      _richtig = 0;
      _falsch = 0;
    });
    final list =
        await MixedQuizRepository.instance.pickSessionQuestions(_random);
    final cum = await MixedQuizRepository.instance.loadState();
    if (!mounted) return;
    setState(() {
      _queue = list;
      _cumulative = cum;
      _phase = _MixedPhase.playing;
    });
  }

  Future<void> _reloadCumulative() async {
    final cum = await MixedQuizRepository.instance.loadState();
    if (!mounted) return;
    setState(() => _cumulative = cum);
  }

  Future<void> _select(int i) async {
    if (_showResult || _current == null) return;
    final q = _current!;
    final ok = i == q.correctIndex;
    await MixedQuizRepository.instance.recordAnswer(q, ok);
    if (!mounted) return;
    setState(() {
      _picked = i;
      _showResult = true;
      if (ok) {
        _richtig++;
      } else {
        _falsch++;
        _sessionWrongByModule[q.module] =
            (_sessionWrongByModule[q.module] ?? 0) + 1;
      }
    });
  }

  void _nextQ() {
    if (_current == null) return;
    final q = _queue!.first;
    final wasCorrect = _picked == q.correctIndex;
    var finished = false;
    setState(() {
      _queue!.removeAt(0);
      if (!wasCorrect) {
        if (_queue!.isEmpty) {
          _queue!.add(q);
        } else {
          final pos = 1 + _random.nextInt(_queue!.length);
          _queue!.insert(pos, q);
        }
      }
      _picked = null;
      _showResult = false;
      if (_queue!.isEmpty) {
        _phase = _MixedPhase.finished;
        finished = true;
      }
    });
    if (finished) {
      _reloadCumulative();
    }
  }

  String _weiterLabel() {
    if (_queue == null || _queue!.isEmpty) return 'Weiter';
    final q = _queue!.first;
    if (_queue!.length == 1 && _showResult && _picked == q.correctIndex) {
      return 'Fertig';
    }
    return 'Weiter';
  }

  @override
  void initState() {
    super.initState();
    _reloadCumulative();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mix — 30 Fragen (Grammatik)'),
      ),
      body: switch (_phase) {
        _MixedPhase.intro => _buildIntro(context, scheme),
        _MixedPhase.loading => const Center(child: CircularProgressIndicator()),
        _MixedPhase.playing => _buildPlaying(context, scheme),
        _MixedPhase.finished => _buildFinished(context, scheme),
      },
    );
  }

  Widget _buildIntro(BuildContext context, ColorScheme scheme) {
    final cum = _cumulative;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Общий микс',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          '30 случайных карточек из всех грамматических модулей (артикли, местоимения, '
          'притяжательные, отделяемые глаголы). Ответы сохраняются: темы и конкретные '
          'вопросы, где вы чаще ошибаетесь, чаще попадут в следующий микс.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 20),
        Text(
          'Накопленно по модулям',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        if (cum == null)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final m in MixedQuizModule.values)
                    if ((cum.moduleStats[m]?.total ?? 0) > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '${mixedQuizModuleLabelRu(m)}: '
                          'верно ${cum.moduleStats[m]!.right}, '
                          'неверно ${cum.moduleStats[m]!.wrong}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                  if (cum.moduleStats.values.every((s) => s.total == 0))
                    Text(
                      'Пока нет данных — пройдите первый микс.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _startSession,
          icon: const Icon(Icons.play_arrow),
          label: const Text('30 Fragen starten'),
        ),
      ],
    );
  }

  Widget _buildPlaying(BuildContext context, ColorScheme scheme) {
    if (_atEnd || _current == null) {
      return const SizedBox.shrink();
    }
    final q = _current!;
    final correct = _picked == q.correctIndex;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_richtig / _kTotal).clamp(0.0, 1.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Верно: $_richtig · Неверно: $_falsch · осталось ${_queue!.length}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              Chip(
                label: Text(
                  '${mixedQuizModuleLabelDe(q.module)} · Nr. ${q.sourceNr} · '
                  'noch ${_queue!.length}',
                ),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: SelectableText(
                    _previewLine(q),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Wählen Sie:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < q.options.length; i++)
                    ChoiceChip(
                      label: Text(q.options[i]),
                      selected: _picked == i,
                      onSelected: _showResult ? null : (_) => _select(i),
                    ),
                ],
              ),
              if (_showResult) ...[
                const SizedBox(height: 20),
                Text(
                  correct ? 'Richtig ✓' : 'Nicht richtig.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: correct ? Colors.green.shade700 : scheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lösung:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                SelectableText(
                  q.solutionDe,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ],
          ),
        ),
        if (_showResult)
          Material(
            elevation: 8,
            color: scheme.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _nextQ,
                    child: Text(_weiterLabel()),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFinished(BuildContext context, ColorScheme scheme) {
    final p = _richtig + _falsch == 0
        ? 0
        : ((_richtig * 100) / (_richtig + _falsch)).round();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(Icons.check_circle_outline, size: 56, color: scheme.primary),
        const SizedBox(height: 16),
        Text(
          'Сессия завершена',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Верно: $_richtig · Неверно: $_falsch · $p%',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          _sessionRecommendationRu(_sessionWrongByModule),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () {
            setState(() {
              _phase = _MixedPhase.intro;
              _queue = null;
            });
            _reloadCumulative();
          },
          child: const Text('Zurück zum Start'),
        ),
      ],
    );
  }
}
