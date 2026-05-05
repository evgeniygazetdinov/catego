/// Убирает неспаренные UTF-16 суррогаты (канал STT, битые строки).
String sanitizeWellFormedUtf16(String s) {
  if (s.isEmpty) return s;
  final units = s.codeUnits;
  final out = <int>[];
  var i = 0;
  while (i < units.length) {
    final c = units[i];
    if (c >= 0xD800 && c <= 0xDBFF) {
      if (i + 1 < units.length) {
        final low = units[i + 1];
        if (low >= 0xDC00 && low <= 0xDFFF) {
          out.add(c);
          out.add(low);
          i += 2;
          continue;
        }
      }
      i++;
    } else if (c >= 0xDC00 && c <= 0xDFFF) {
      i++;
    } else {
      out.add(c);
      i++;
    }
  }
  return String.fromCharCodes(out);
}
