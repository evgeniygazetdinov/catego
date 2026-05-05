// dart run tool/hoeren_glossary_audit.dart
import 'package:risuem_s/data/hoeren_exercises.dart';
import 'package:risuem_s/data/hoeren_glossary.dart';

/// Те же правила, что у [TappableHortext] — только поверхностные токены-слова.
Iterable<String> _wordSurfaces(String text) sync* {
  final pattern = RegExp(
    r"\s+|\d+:\d+|\d+[.,]\d+|[A-Za-zÄÖÜäöüß]+(?:[-'][A-Za-zÄÖÜäöüß]+)*|\d+|[^A-Za-zÄÖÜäöüß0-9\s]",
  );
  for (final m in pattern.allMatches(text)) {
    final s = m.group(0)!;
    if (RegExp(r'^\s+$').hasMatch(s)) continue;
    if (RegExp(r'^\d+:\d+$').hasMatch(s)) yield s;
    if (RegExp(r'^\d+[.,]\d+$').hasMatch(s)) yield s;
    if (RegExp(r'^\d+$').hasMatch(s)) yield s;
    if (RegExp(r'^[A-Za-zÄÖÜäöüß]').hasMatch(s)) yield s;
  }
}

void main() {
  final keys = <String>{};
  for (final e in allHoerenExercises()) {
    for (final surf in _wordSurfaces(e.hortext)) {
      final k = normalizeGermanToken(surf);
      if (k.isEmpty) continue;
      keys.add(k);
    }
    for (final en in e.wordHints.keys) {
      keys.add(normalizeGermanToken(en));
    }
  }

  bool hasEntry(String k) =>
      kHoerenGlossary.containsKey(k) || kHoerenGlossarySupplement.containsKey(k);

  final missing = keys.where((k) => !hasEntry(k)).toList()..sort();
  // ignore: avoid_print
  print('Всего уникальных ключей: ${keys.length}');
  // ignore: avoid_print
  print('Нет в объединённом словаре: ${missing.length}');
  for (final m in missing) {
    // ignore: avoid_print
    print(m);
  }
}
