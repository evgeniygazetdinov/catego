/// Нормализация и сравнение распознанной речи с эталоном (немецкий текст).

import 'utf16_sanitize.dart';

/// Убирает пунктуацию, лишние пробелы, приводит к нижнему регистру,
/// упрощает умлауты (распознаватель часто даёт «ae» вместо «ä»).
String normalizeForSpeechCompare(String input) {
  var s = sanitizeWellFormedUtf16(input).toLowerCase().trim();
  s = s.replaceAll('ä', 'a');
  s = s.replaceAll('ö', 'o');
  s = s.replaceAll('ü', 'u');
  s = s.replaceAll('ß', 'ss');
  s = s.replaceAll(RegExp(r'[^a-z0-9]+'), ' ');
  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  return s;
}

int _levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final m = a.length;
  final n = b.length;
  final d = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  for (var i = 0; i <= m; i++) {
    d[i][0] = i;
  }
  for (var j = 0; j <= n; j++) {
    d[0][j] = j;
  }
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      var best = d[i - 1][j] + 1;
      final ins = d[i][j - 1] + 1;
      if (ins < best) best = ins;
      final sub = d[i - 1][j - 1] + cost;
      if (sub < best) best = sub;
      d[i][j] = best;
    }
  }
  return d[m][n];
}

/// 0.0 … 1.0 по расстоянию Левенштейна между нормализованными строками.
double speechTextSimilarity(String expected, String recognized) {
  final e = normalizeForSpeechCompare(expected);
  final r = normalizeForSpeechCompare(recognized);
  if (e.isEmpty && r.isEmpty) return 1;
  if (e.isEmpty || r.isEmpty) return 0;
  final dist = _levenshtein(e, r);
  final maxLen = e.length > r.length ? e.length : r.length;
  return 1.0 - dist / maxLen;
}
