import 'package:flutter/material.dart';

/// Модуль «Говорение»: знакомство, тематические карточки, вежливые формулы.
class SprechenScreen extends StatelessWidget {
  const SprechenScreen({super.key});

  static const _teil1 = <String>[
    'Sich vorstellen: Name, Herkunft, Wohnort, Sprachen.',
    'Buchstabieren: Namen, E-Mail-Adresse, Straße (Buchstaben deutlich).',
    'Zahlen: Telefonnummer, Uhrzeit, Preis, Datum.',
  ];

  static const _teil2 = <String>[
    'Themenkarten: kurz antworten (ca. 1 Minute) zu Alltagsthemen '
        '(Freizeit, Arbeit, Familie, Essen, Wetter …).',
    'Struktur: Einleitung → 2–3 Sätze Inhalt → kurzer Abschluss.',
  ];

  static const _teil3 = <String>[
    'Höfliche Bitten: „Könnten Sie mir bitte …?“, „Darf ich …?“, „Würden Sie …?“',
    'Formeln: Entschuldigung, Dank, Einverständnis, Wiederholung bitten.',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sprechen — Говорение'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '1. Kennenlernen'),
              Tab(text: '2. Themenkarten'),
              Tab(text: '3. Höfliche Bitten'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TeilPanel(
              title: 'Teil 1 — Знакомство',
              subtitle:
                  'Buchstabieren, Zahlen: Sie stellen sich vor und beantworten einfache Fragen zur Person.',
              ruHint:
                  'Эта часть: знакомство (буквы по алфавиту, числа — телефон, время, цена).',
              points: _teil1,
            ),
            _TeilPanel(
              title: 'Teil 2 — Themenkarten',
              subtitle:
                  'Sie ziehen eine Karte mit einem Thema und sprechen frei dazu.',
              ruHint:
                  'Карточки с вопросами: короткий связный монолог по теме.',
              points: _teil2,
            ),
            _TeilPanel(
              title: 'Teil 3 — Höfliche Bitten / Formeln',
              subtitle:
                  'Feststehende Redewendungen für Alltagssituationen (Bahnhof, Restaurant, Behörde …).',
              ruHint:
                  'Вежливые просьбы и устойчивые формулы в типичных ситуациях.',
              points: _teil3,
            ),
          ],
        ),
      ),
    );
  }
}

class _TeilPanel extends StatelessWidget {
  const _TeilPanel({
    required this.title,
    required this.subtitle,
    required this.ruHint,
    required this.points,
  });

  final String title;
  final String subtitle;
  final String ruHint;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text(
          ruHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        ...points.map(
          (p) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(p, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
            ),
          ),
        ),
      ],
    );
  }
}
