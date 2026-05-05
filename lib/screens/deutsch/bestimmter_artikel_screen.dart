import 'package:flutter/material.dart';

import '../../data/bestimmter_artikel_questions.dart';
import '../../data/bestimmter_artikel_theory.dart';

/// Теория + 50 заданий по bestimmtem Artikel (A1).
class BestimmterArtikelScreen extends StatefulWidget {
  const BestimmterArtikelScreen({super.key});

  @override
  State<BestimmterArtikelScreen> createState() => _BestimmterArtikelScreenState();
}

class _BestimmterArtikelScreenState extends State<BestimmterArtikelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late List<BestimmterArtikelFrage> _fragen;
  int _qIndex = 0;
  int? _picked;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _fragen = allBestimmterArtikelFragen();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  bool get _atEnd => _qIndex >= _fragen.length;
  BestimmterArtikelFrage? get _current => _atEnd ? null : _fragen[_qIndex];

  String _previewLine(BestimmterArtikelFrage q) {
    final mid = _picked == null ? '___' : q.options[_picked!];
    final gap = _picked == null ? '___ ' : '$mid ';
    return '${q.beforeGap}$gap${q.afterGap}';
  }

  void _select(int i) {
    if (_showResult || _current == null) return;
    setState(() {
      _picked = i;
      _showResult = true;
    });
  }

  void _nextQ() {
    setState(() {
      _qIndex++;
      _picked = null;
      _showResult = false;
    });
  }

  void _restartFragen() {
    setState(() {
      _qIndex = 0;
      _picked = null;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bestimmter Artikel — A1'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Теория'),
            Tab(text: '50 Fragen'),
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
          'Bestimmter Artikel (der, die, das, den)',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Start Deutsch 1 — теория и сноска перед упражнениями (вторая вкладка).',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        for (final sec in kBestimmterArtikelTheorySections) ...[
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                'Alle 50 Aufgaben durch',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                'Сверьтесь с ключом в карточках заданий или пройдите снова.',
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
        LinearProgressIndicator(value: (q.nr) / _fragen.length),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Text(
                'Сначала при необходимости откройте вкладку «Теория».',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text('${teilLabelDe(q.teil)} · Nr. ${q.nr}/50'),
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
                    child: Text(
                      q.nr >= _fragen.length ? 'Fertig' : 'Weiter',
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
