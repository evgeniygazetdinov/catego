import 'akkusativ_artikel_questions.dart';
import 'bestimmter_artikel_questions.dart';
import 'dativ_artikel_questions.dart';
import 'mixed_quiz_models.dart';
import 'personalpronomen_akkusativ_questions.dart';
import 'personalpronomen_dativ_questions.dart';
import 'possessivartikel_akkusativ_questions.dart';
import 'possessivartikel_nom_akk_questions.dart';
import 'possessivartikel_nominativ_questions.dart';
import 'trennbare_verben_questions.dart';

/// Все карточки из грамматических модулей (без Hören/Lesen/Sprechen).
List<MixedQuizItem> loadMixedQuizPool() {
  final out = <MixedQuizItem>[];

  for (final q in allBestimmterArtikelFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.bestimmterArtikel,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allAkkusativArtikelFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.akkusativArtikel,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allDativArtikelFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.dativArtikel,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allPersonalpronomenAkkFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.personalpronomenAkkusativ,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allPersonalpronomenDatFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.personalpronomenDativ,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allPossessivartikelAkkFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.possessivartikelAkkusativ,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allPossessivartikelNomFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.possessivartikelNominativ,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allPossessivartikelNomAkkFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.possessivartikelNomAkk,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  for (final q in allTrennbarVerbenFragen()) {
    out.add(MixedQuizItem(
      module: MixedQuizModule.trennbareVerben,
      sourceNr: q.nr,
      beforeGap: q.beforeGap,
      afterGap: q.afterGap,
      options: List<String>.from(q.options),
      correctIndex: q.correctIndex,
      solutionDe: q.solutionDe,
    ));
  }
  return out;
}
