import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database_provider.dart';
import '../../../problem_log/data/models/problem_model.dart';
import '../../../problem_log/presentation/providers/problem_provider.dart';
import '../../data/models/topic_model.dart';

final customTopicsProvider = StreamProvider<List<TopicModel>>((ref) {
  final isar = ref.watch(isarProvider);
  return isar.topicModels.watchLazy(fireImmediately: true).asyncMap((_) async {
    final all = await isar.topicModels.filter().idGreaterThan(0).findAll();
    all.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return all;
  });
});

// Per-topicId count of solved problems (reactive, updates with allProblemsProvider)
final topicSolvedCountProvider = Provider<Map<String, int>>((ref) {
  final problems = ref.watch(allProblemsProvider).valueOrNull ?? [];
  final counts = <String, int>{};
  for (final p in problems) {
    if (p.status == ProblemStatus.solved) {
      counts[p.topicId] = (counts[p.topicId] ?? 0) + 1;
    }
  }
  return counts;
});

// Topic mastery list for analytics: only topics with ≥1 solved, sorted worst→best
final topicMasteryProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final topics = ref.watch(customTopicsProvider).valueOrNull ?? [];
  final solvedCounts = ref.watch(topicSolvedCountProvider);
  final result = <Map<String, dynamic>>[];
  for (final t in topics) {
    final solved = solvedCounts[t.topicId] ?? 0;
    if (solved == 0 || t.estimatedProblems <= 0) continue;
    final pct = (solved / t.estimatedProblems * 100).round().clamp(0, 100);
    result.add({
      'topicId': t.topicId,
      'name': t.name,
      'solved': solved,
      'total': t.estimatedProblems,
      'pct': pct,
    });
  }
  result.sort((a, b) => (a['pct'] as int).compareTo(b['pct'] as int));
  return result;
});

const _striverSectionNames = [
  'Arrays [Easy → Hard]',
  'Binary Search',
  'Strings',
  'Linked List',
  'Recursion & Backtracking',
  'Bit Manipulation',
  'Stack & Queue',
  'Sliding Window & Two Pointer',
  'Heaps',
  'Greedy Algorithms',
  'Binary Trees',
  'Binary Search Trees',
  'Graphs',
  'Dynamic Programming',
  'Tries',
  'Strings II',
  'Segment Tree',
  'Miscellaneous',
];

final striverSectionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final problems = ref.watch(allProblemsProvider).valueOrNull ?? [];
  final results = <Map<String, dynamic>>[];
  for (var i = 0; i < _striverSectionNames.length; i++) {
    final topicId = 'striver_${i + 1}';
    final section = problems.where((p) => p.topicId == topicId).toList();
    final solved =
        section.where((p) => p.status == ProblemStatus.solved).length;
    results.add({
      'id': i + 1,
      'name': _striverSectionNames[i],
      'total': section.length,
      'solved': solved,
    });
  }
  return results;
});
