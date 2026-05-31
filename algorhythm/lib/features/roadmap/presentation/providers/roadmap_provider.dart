import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database_provider.dart';
import '../../../problem_log/data/models/problem_model.dart';
import '../../data/models/topic_model.dart';

final customTopicsProvider = StreamProvider<List<TopicModel>>((ref) {
  final isar = ref.watch(isarProvider);
  return isar.topicModels.watchLazy(fireImmediately: true).asyncMap((_) async {
    // idGreaterThan(0) matches all auto-increment IDs (which start at 1)
    final all = await isar.topicModels.filter().idGreaterThan(0).findAll();
    all.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return all;
  });
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

final striverSectionsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final isar = ref.watch(isarProvider);
  final all =
      await isar.problemModels.filter().idGreaterThan(0).findAll();

  final results = <Map<String, dynamic>>[];
  for (var i = 0; i < _striverSectionNames.length; i++) {
    final topicId = 'striver_${i + 1}';
    final section = all.where((p) => p.topicId == topicId).toList();
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
