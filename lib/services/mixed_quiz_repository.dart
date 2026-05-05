import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/mixed_quiz_models.dart';
import '../data/mixed_quiz_pool.dart';

class ModuleAnswerStats {
  ModuleAnswerStats({this.right = 0, this.wrong = 0});

  int right;
  int wrong;

  int get total => right + wrong;
}

/// Накопленная статистика и веса для приоритета «проблемных» вопросов.
class MixedQuizPersistentState {
  MixedQuizPersistentState({
    Map<String, int>? questionWrong,
    Map<MixedQuizModule, ModuleAnswerStats>? moduleStats,
  })  : questionWrong = questionWrong ?? {},
        moduleStats = moduleStats ?? {
          for (final m in MixedQuizModule.values) m: ModuleAnswerStats(),
        };

  /// Сколько раз ошибались на конкретной карточке (по stableId).
  final Map<String, int> questionWrong;
  final Map<MixedQuizModule, ModuleAnswerStats> moduleStats;

  double weightFor(MixedQuizItem e) {
    final qw = questionWrong[e.stableId] ?? 0;
    final ms = moduleStats[e.module] ?? ModuleAnswerStats();
    final ratio = ms.total == 0 ? 0.0 : ms.wrong / ms.total;
    return 1.0 + 3.5 * qw + 6.0 * ratio;
  }

  static MixedQuizPersistentState fromPrefsJson(String? raw) {
    if (raw == null || raw.isEmpty) {
      return MixedQuizPersistentState();
    }
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final qw = <String, int>{};
      final qwRaw = j['qw'];
      if (qwRaw is Map) {
        for (final e in qwRaw.entries) {
          final v = e.value;
          if (v is int) {
            qw[e.key.toString()] = v.clamp(0, 30);
          } else if (v is num) {
            qw[e.key.toString()] = v.toInt().clamp(0, 30);
          }
        }
      }
      final ms = <MixedQuizModule, ModuleAnswerStats>{};
      final msRaw = j['ms'];
      if (msRaw is Map) {
        for (final m in MixedQuizModule.values) {
          final key = m.name;
          final block = msRaw[key];
          if (block is Map) {
            final r = (block['r'] is num) ? (block['r'] as num).toInt() : 0;
            final w = (block['w'] is num) ? (block['w'] as num).toInt() : 0;
            ms[m] = ModuleAnswerStats(right: r.clamp(0, 1 << 20), wrong: w.clamp(0, 1 << 20));
          } else {
            ms[m] = ModuleAnswerStats();
          }
        }
      }
      for (final m in MixedQuizModule.values) {
        ms.putIfAbsent(m, () => ModuleAnswerStats());
      }
      return MixedQuizPersistentState(questionWrong: qw, moduleStats: ms);
    } catch (_) {
      return MixedQuizPersistentState();
    }
  }

  String toPrefsJson() {
    final qw = <String, int>{};
    questionWrong.forEach((k, v) {
      if (v > 0) qw[k] = v.clamp(0, 30);
    });
    final ms = <String, Map<String, int>>{};
    for (final e in moduleStats.entries) {
      ms[e.key.name] = {'r': e.value.right, 'w': e.value.wrong};
    }
    return jsonEncode({'qw': qw, 'ms': ms});
  }

  MixedQuizPersistentState copy() {
    final qw = Map<String, int>.from(questionWrong);
    final ms = {
      for (final m in MixedQuizModule.values)
        m: ModuleAnswerStats(
          right: moduleStats[m]?.right ?? 0,
          wrong: moduleStats[m]?.wrong ?? 0,
        ),
    };
    return MixedQuizPersistentState(questionWrong: qw, moduleStats: ms);
  }

  void applyAnswer(MixedQuizItem q, bool ok) {
    final ms = moduleStats.putIfAbsent(q.module, ModuleAnswerStats.new);
    if (ok) {
      ms.right++;
      final prev = questionWrong[q.stableId] ?? 0;
      if (prev <= 0) {
        questionWrong.remove(q.stableId);
      } else {
        questionWrong[q.stableId] = prev - 1;
      }
    } else {
      ms.wrong++;
      questionWrong[q.stableId] = ((questionWrong[q.stableId] ?? 0) + 1).clamp(0, 30);
    }
  }
}

class MixedQuizRepository {
  MixedQuizRepository._();
  static final MixedQuizRepository instance = MixedQuizRepository._();

  static const _prefsKey = 'mixed_quiz_state_v1';

  List<MixedQuizItem>? _pool;

  List<MixedQuizItem> get pool => _pool ??= loadMixedQuizPool();

  Future<MixedQuizPersistentState> loadState() async {
    final p = await SharedPreferences.getInstance();
    return MixedQuizPersistentState.fromPrefsJson(p.getString(_prefsKey));
  }

  Future<void> saveState(MixedQuizPersistentState s) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_prefsKey, s.toPrefsJson());
  }

  /// 30 карточек: вес растёт с ошибками по вопросу и по доле ошибок в модуле; порядок затем перемешивается.
  Future<List<MixedQuizItem>> pickSessionQuestions(Random rng) async {
    final state = await loadState();
    final full = List<MixedQuizItem>.from(pool);
    if (full.length <= 30) {
      full.shuffle(rng);
      return full;
    }

    final remaining = List<MixedQuizItem>.from(full);
    final weights = remaining.map(state.weightFor).toList();
    final picked = <MixedQuizItem>[];

    for (var n = 0; n < 30; n++) {
      var sum = 0.0;
      for (final w in weights) {
        sum += w;
      }
      if (sum <= 0 || remaining.isEmpty) break;
      var r = rng.nextDouble() * sum;
      var idx = 0;
      for (var i = 0; i < remaining.length; i++) {
        r -= weights[i];
        if (r <= 0) {
          idx = i;
          break;
        }
        idx = i;
      }
      picked.add(remaining[idx]);
      remaining.removeAt(idx);
      weights.removeAt(idx);
    }

    picked.shuffle(rng);
    return picked;
  }

  Future<void> recordAnswer(MixedQuizItem q, bool ok) async {
    final s = await loadState();
    final next = s.copy();
    next.applyAnswer(q, ok);
    await saveState(next);
  }
}
