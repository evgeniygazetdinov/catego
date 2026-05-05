import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

import 'linux_shell_tts.dart';

/// Короткая озвучка одного немецкого слова (словарь Hören / Lesen).
class GermanWordTts {
  GermanWordTts._();
  static final GermanWordTts instance = GermanWordTts._();

  final FlutterTts _flutter = FlutterTts();
  final LinuxShellTts _linux = LinuxShellTts();
  bool _flutterReady = false;

  bool get _useLinux => !kIsWeb && isLinuxHost;

  Future<void> _ensureFlutter() async {
    if (_flutterReady || _useLinux) return;
    try {
      await _flutter.setLanguage('de-DE');
      await _flutter.setSpeechRate(0.48);
      _flutterReady = true;
    } catch (_) {
      _flutterReady = false;
    }
  }

  /// Произнести [text] (одно слово или короткая фраза).
  Future<void> speak(String text) async {
    final w = text.trim();
    if (w.isEmpty) return;
    try {
      if (_useLinux) {
        await _linux.stop();
        await _linux.speak(w);
        return;
      }
      await _ensureFlutter();
      if (!_flutterReady) return;
      await _flutter.stop();
      await _flutter.speak(w);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      if (_useLinux) {
        await _linux.stop();
      } else if (_flutterReady) {
        await _flutter.stop();
      }
    } catch (_) {}
  }
}
