import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../utils/lesen_speech_compare.dart';
import '../../utils/utf16_sanitize.dart';

/// Модуль «Чтение»: объявления, письма, таблички → richtig/falsch или сопоставление.
class LesenScreen extends StatefulWidget {
  const LesenScreen({super.key});

  @override
  State<LesenScreen> createState() => _LesenScreenState();
}

class _LesenScreenState extends State<LesenScreen> {
  bool? _answered;

  final SpeechToText _speech = SpeechToText();
  bool _speechInitDone = false;
  bool _speechUsable = false;
  String? _deLocaleId;
  bool _listening = false;
  String _heard = '';
  double? _lastSimilarity;

  static const _text = '''
Bahnhofstraße 12
10115 Berlin

Liebe Kundinnen und Kunden,

unsere Filiale bleibt am Samstag, den 15. Juni, wegen Inventur geschlossen.
Am Sonntag sind wir wie gewohnt von 10 bis 18 Uhr für Sie da.

Ihr Team vom Buchladen „Leselust“
''';

  static const _statement = 'Am Samstag, den 15. Juni, ist der Buchladen geöffnet.';

  /// Одно предложение из письма — по нему проверяем устное чтение.
  static const _speechTarget =
      'Am Sonntag sind wir wie gewohnt von 10 bis 18 Uhr für Sie da.';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    var ok = false;
    String? locale;
    try {
      ok = await _speech.initialize(
        onError: (e) {
          if (mounted) {
            setState(() {});
            final msg = sanitizeWellFormedUtf16(e.errorMsg);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Spracherkennung: $msg'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'done' || status == 'notListening') {
            setState(() => _listening = false);
          }
        },
      );
      if (ok) {
        final locales = await _speech.locales();
        for (final l in locales) {
          final id = l.localeId.toLowerCase();
          if (id.startsWith('de')) {
            locale = l.localeId;
            if (id == 'de_de') break;
          }
        }
      }
    } catch (e, st) {
      ok = false;
      locale = null;
      debugPrint('speech_to_text initialize: $e\n$st');
    }
    if (!mounted) return;
    setState(() {
      _speechInitDone = true;
      _speechUsable = ok && locale != null;
      _deLocaleId = locale;
    });
  }

  @override
  void dispose() {
    try {
      _speech.cancel();
    } catch (_) {}
    super.dispose();
  }

  void _check(bool userChoseRichtig) {
    final isCorrect = !userChoseRichtig;
    setState(() => _answered = isCorrect);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? 'Richtig — gut gelesen!'
              : 'Noch einmal: der Text sagt "geschlossen" am Samstag.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleListen() async {
    if (!_speechUsable || _deLocaleId == null) return;
    if (_listening) {
      try {
        await _speech.stop();
      } catch (_) {}
      setState(() => _listening = false);
      return;
    }
    setState(() {
      _heard = '';
      _lastSimilarity = null;
      _listening = true;
    });
    try {
      await _speech.listen(
      onResult: (r) {
        if (!mounted) return;
        final words = sanitizeWellFormedUtf16(r.recognizedWords);
        setState(() => _heard = words);
        if (r.finalResult) {
          final sim = speechTextSimilarity(_speechTarget, words);
          setState(() {
            _lastSimilarity = sim;
            _listening = false;
          });
          if (!mounted) return;
          final msg = sim >= 0.78
              ? 'Sehr nah am Text — weiter so!'
              : sim >= 0.55
                  ? 'Schon gut — versuchen Sie es noch einmal etwas deutlicher.'
                  : 'Viel Unterschied — langsamer lesen und erneut aufnehmen.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
          );
        }
      },
      localeId: _deLocaleId,
      pauseFor: const Duration(seconds: 3),
      listenFor: const Duration(seconds: 45),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
    );
    } catch (e, st) {
      debugPrint('speech_to_text listen: $e\n$st');
      if (mounted) {
        setState(() => _listening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mikrofon / Spracherkennung auf dieser Plattform nicht verfügbar.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesen — Чтение')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Lesen Sie die Texte (Aushänge, Briefe, Schilder). '
            'Entscheiden Sie: richtig oder falsch — oder ordnen Sie Text und Situation zu.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Здесь вы читаете объявления, письма и таблички и отвечаете «richtig» или «falsch», '
            'либо сопоставляете текст и ситуацию. Ниже можно прочитать фразу вслух в микрофон — '
            'приложение сравнит распознанный текст с эталоном (Android / iOS; на Linux обычно недоступно).',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _text.trim(),
                style: const TextStyle(height: 1.5, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSpeechCard(context),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.55),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aussage', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  const Text(
                    _statement,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text('Ist die Aussage richtig oder falsch?', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: () => _check(true),
                        child: const Text('richtig'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.tonal(
                        onPressed: () => _check(false),
                        child: const Text('falsch'),
                      ),
                    ],
                  ),
                  if (_answered != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _answered! ? 'Sehr gut!' : 'Tipp: nochmal den ersten Satz lesen.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!_speechInitDone) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (!_speechUsable) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Распознавание речи недоступно на этой платформе или нет языка «de» в системе. '
            'Попробуйте Android / iOS и установите немецкий для ввода речи в настройках.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Laut lesen', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              _speechTarget,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Нажмите микрофон и прочитайте предложение. Остановка — снова на кнопку.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: _toggleListen,
                  icon: Icon(_listening ? Icons.stop_rounded : Icons.mic_rounded),
                  label: Text(_listening ? 'Stopp' : 'Aufnehmen'),
                ),
                if (_listening) ...[
                  const SizedBox(width: 12),
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
            if (_heard.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Erkannt:', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(_heard, style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (_lastSimilarity != null) ...[
              const SizedBox(height: 8),
              Text(
                'Übereinstimmung: ${(_lastSimilarity! * 100).round()} % '
                '(nur grobe Schätzung, keine Prüfungsnote).',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
