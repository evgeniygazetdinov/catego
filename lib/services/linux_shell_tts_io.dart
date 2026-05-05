import 'dart:io';

bool get isLinuxHost => Platform.isLinux;

/// Озвучка через espeak-ng / espeak / spd-say (Linux без flutter_tts).
/// Скорость/тон/паузы мягче дефолта; голос — dart-define `ESPEAK_NG_VOICE` (по умолчанию `de+m2`).
class LinuxShellTts {
  Process? _process;

  /// Слов в минуту (дефолт espeak ~175). Ниже — спокойнее и разборчивее.
  static const int _espeakWordsPerMinute = 132;

  /// Высота 0–99, центр 50. Чуть ниже — менее «пискляво».
  static const int _espeakPitch = 44;

  /// Пауза между словами, шаг 10 ms (дефолт 0). Небольшое значение сглаживает поток.
  static const int _espeakWordGap = 6;

  /// Вариант голоса: `de` везде есть; `de+m2` / `de+f2` часто звучат мягче (если есть в дистрибутиве).
  /// Для Mbrola: `mb-de4` (нужен пакет mbrola + mbrola-de4).
  static const String _espeakGermanVoice = String.fromEnvironment(
    'ESPEAK_NG_VOICE',
    defaultValue: 'de+m2',
  );

  Future<bool> speak(String text, {void Function()? onComplete}) async {
    await stop();
    final cmd = await _commandFor(text);
    if (cmd == null) return false;
    try {
      _process = await Process.start(cmd.$1, cmd.$2);
    } catch (_) {
      return false;
    }
    final p = _process!;
    p.exitCode.whenComplete(() {
      if (identical(_process, p)) _process = null;
      onComplete?.call();
    });
    return true;
  }

  Future<void> stop() async {
    final p = _process;
    _process = null;
    if (p != null) {
      try {
        p.kill();
      } catch (_) {}
    }
  }

  Future<(String, List<String>)?> _commandFor(String text) async {
    if (await _hasExecutable('espeak-ng')) {
      return (
        'espeak-ng',
        [
          '-v',
          _espeakGermanVoice,
          '-s',
          '$_espeakWordsPerMinute',
          '-p',
          '$_espeakPitch',
          '-g',
          '$_espeakWordGap',
          text,
        ],
      );
    }
    if (await _hasExecutable('espeak')) {
      return (
        'espeak',
        [
          '-v',
          'de',
          '-s',
          '$_espeakWordsPerMinute',
          '-p',
          '$_espeakPitch',
          '-g',
          '$_espeakWordGap',
          text,
        ],
      );
    }
    if (await _hasExecutable('spd-say')) {
      return (
        'spd-say',
        [
          '-l',
          'de',
          '-r',
          '-22',
          '-p',
          '-12',
          text,
        ],
      );
    }
    return null;
  }

  Future<bool> _hasExecutable(String name) async {
    final r = await Process.run('which', [name]);
    return r.exitCode == 0;
  }
}
