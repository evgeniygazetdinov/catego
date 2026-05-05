import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/dativ_artikel_questions.dart';
import '../../data/dativ_artikel_theory.dart';
import '../../utils/artikel_stats_feedback.dart';

/// Теория + упражнения Artikel im Dativ (A1 / Start Deutsch 1).
class DativArtikelScreen extends StatefulWidget {
  const DativArtikelScreen({super.key});

  @override
  State<DativArtikelScreen> createState() => _DativArtikelScreenState();
}

class _DativArtikelScreenState extends State<DativArtikelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late List<DativArtikelFrage> _queue;
  late int _zielAnzahl;
  final Random _random = Random();
  int? _picked;
  bool _showResult = false;
  int _richtig = 0;
  int _falsch = 0;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _queue = List<DativArtikelFrage>.from(allDativArtikelFragen());
    _zielAnzahl = _queue.length;
    _queue.shuffle(_random);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  bool get _atEnd => _queue.isEmpty;
  DativArtikelFrage? get _current => _atEnd ? null : _queue.first;

  String _previewLine(DativArtikelFrage q) {
    final mid = _picked == null ? '___' : q.options[_picked!];
    final gap = _picked == null ? '___ ' : '$mid ';
    return '${q.beforeGap}$gap${q.afterGap}';
  }

  void _select(int i) {
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

  void _nextQ() {
    if (_current == null) return;
    final q = _queue.first;
    final wasCorrect = _picked == q.correctIndex;
    setState(() {
      _queue.removeAt(0);
      if (!wasCorrect) {
        if (_queue.isEmpty) {
          _queue.add(q);
        } else {
          final pos = 1 + _random.nextInt(_queue.length);
          _queue.insert(pos, q);
        }
      }
      _picked = null;
      _showResult = false;
    });
  }

  void _restartFragen() {
    setState(() {
      _queue = List<DativArtikelFrage>.from(allDativArtikelFragen());
      _zielAnzahl = _queue.length;
      _queue.shuffle(_random);
      _picked = null;
      _showResult = false;
      _richtig = 0;
      _falsch = 0;
    });
  }

  String _weiterButtonLabel() {
    final q = _queue.first;
    if (_queue.length == 1 && _showResult && _picked == q.correctIndex) {
      return 'Fertig';
    }
    return 'Weiter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel im Dativ — A1'),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            const Tab(text: 'Теория'),
            Tab(text: 'Fragen ($_zielAnzahl)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildTheoryTab(context),
          _buildFragenTab(context),
        ],
      ),
    );
  }

  Widget _buildTheoryTab(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text(
          'Artikel im Dativ',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Start Deutsch 1: Wem?, Präpositionen, Verben, Wo? Вторая вкладка — 150 заданий.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        for (final sec in kDativArtikelTheorySections) ...[
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

  Widget _buildFragenTab(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_atEnd) {
      final p = artikelAntwortProzent(_richtig, _falsch) ?? 0;
      final fb = artikelFeedbackNachProzent(p, ArtikelStatsModul.dativ);
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                'Alle $_zielAnzahl Aufgaben durch',
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
                'Сверьтесь с разделом «Теория» при необходимости.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _restartFragen,
                child: const Text('Noch einmal'),
              ),
            ],
          ),
        ),
      );
    }

    final q = _current!;
    final correct = _picked == q.correctIndex;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_richtig / _zielAnzahl).clamp(0.0, 1.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              artikelStatistikZeileRu(_richtig, _falsch),
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
              Text(
                'При необходимости откройте вкладку «Теория». '
                'При ошибке задание вернётся позже в очередь.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text(
                  '${dativArtikelTeilLabelDe(q.teil)} · Nr. ${q.nr}/$_zielAnzahl · '
                  'noch ${_queue.length}',
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
                    child: Text(_weiterButtonLabel()),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
