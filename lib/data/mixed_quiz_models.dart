/// Источники вопросов для общего микс-теста (только грамматические модули).
enum MixedQuizModule {
  bestimmterArtikel,
  akkusativArtikel,
  dativArtikel,
  personalpronomenAkkusativ,
  personalpronomenDativ,
  possessivartikelAkkusativ,
  possessivartikelNominativ,
  possessivartikelNomAkk,
  trennbareVerben,
}

String mixedQuizModuleLabelDe(MixedQuizModule m) {
  return switch (m) {
    MixedQuizModule.bestimmterArtikel => 'Artikel (Nom.)',
    MixedQuizModule.akkusativArtikel => 'Artikel Akk.',
    MixedQuizModule.dativArtikel => 'Artikel Dat.',
    MixedQuizModule.personalpronomenAkkusativ => 'Pron. Akk.',
    MixedQuizModule.personalpronomenDativ => 'Pron. Dat.',
    MixedQuizModule.possessivartikelAkkusativ => 'Poss. Akk.',
    MixedQuizModule.possessivartikelNominativ => 'Poss. Nom.',
    MixedQuizModule.possessivartikelNomAkk => 'Poss. Nom./Akk.',
    MixedQuizModule.trennbareVerben => 'Trennbare Verben',
  };
}

String mixedQuizModuleLabelRu(MixedQuizModule m) {
  return switch (m) {
    MixedQuizModule.bestimmterArtikel => 'Артикли (им. п.)',
    MixedQuizModule.akkusativArtikel => 'Артикль, вин. п.',
    MixedQuizModule.dativArtikel => 'Артикль, дат. п.',
    MixedQuizModule.personalpronomenAkkusativ => 'Местоимения, вин. п.',
    MixedQuizModule.personalpronomenDativ => 'Местоимения, дат. п.',
    MixedQuizModule.possessivartikelAkkusativ => 'Притяжат. артикли, вин. п.',
    MixedQuizModule.possessivartikelNominativ => 'Притяжат. артикли, им. п.',
    MixedQuizModule.possessivartikelNomAkk => 'Притяжат. Nom./Akk.',
    MixedQuizModule.trennbareVerben => 'Отделяемые глаголы',
  };
}

/// Единый формат карточки для микс-сессии.
class MixedQuizItem {
  const MixedQuizItem({
    required this.module,
    required this.sourceNr,
    required this.beforeGap,
    required this.afterGap,
    required this.options,
    required this.correctIndex,
    required this.solutionDe,
  });

  final MixedQuizModule module;
  final int sourceNr;
  final String beforeGap;
  final String afterGap;
  final List<String> options;
  final int correctIndex;
  final String solutionDe;

  String get stableId => '${module.name}_$sourceNr';
}
