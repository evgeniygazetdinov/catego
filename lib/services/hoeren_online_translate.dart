import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/hoeren_glossary.dart';
import '../utils/utf16_sanitize.dart';

/// Подстановка перевода из сети, если слова нет в локальном словаре.
/// Публичный API MyMemory; есть суточные лимиты — результат кэшируется в памяти.
class HoerenOnlineTranslate {
  HoerenOnlineTranslate._();
  static final HoerenOnlineTranslate instance = HoerenOnlineTranslate._();

  final Map<String, String> _cache = {};
  static const int _maxCache = 500;

  static bool _worthFetching(String normalized) {
    if (normalized.isEmpty) return false;
    if (normalized.length == 1 &&
        RegExp(r'^[a-zäöüß]$').hasMatch(normalized)) {
      return false;
    }
    return true;
  }

  Future<String?> deToRu(String surface) async {
    final key = normalizeGermanToken(surface);
    if (!_worthFetching(key)) return null;

    final cached = _cache[key];
    if (cached != null) return cached;

    final uri = Uri.https('api.mymemory.translated.net', '/get', {
      'q': key,
      'langpair': 'de|ru',
    });

    try {
      final resp = await http
          .get(
            uri,
            headers: {
              'User-Agent': 'operative-memory/1.0 (Flutter; educational)',
            },
          )
          .timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return null;
      final data = jsonDecode(resp.body);
      if (data is! Map<String, dynamic>) return null;
      if (data['quotaFinished'] == true) return null;
      final rd = data['responseData'];
      if (rd is! Map<String, dynamic>) return null;
      final text = rd['translatedText'] as String?;
      if (text == null || text.isEmpty) return null;
      final cleaned = sanitizeWellFormedUtf16(text.trim());
      if (cleaned.isEmpty) return null;
      if (_cache.length >= _maxCache) {
        _cache.remove(_cache.keys.first);
      }
      _cache[key] = cleaned;
      return cleaned;
    } catch (_) {
      return null;
    }
  }
}
