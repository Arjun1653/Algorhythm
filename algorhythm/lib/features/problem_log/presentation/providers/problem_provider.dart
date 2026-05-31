import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/models/problem_model.dart';
import '../../data/repositories/problem_repository.dart';

final problemRepositoryProvider = Provider<ProblemRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return ProblemRepository(isar);
});

final allProblemsProvider = StreamProvider<List<ProblemModel>>((ref) {
  return ref.watch(problemRepositoryProvider).watchAll();
});

final problemsByStatusProvider =
    StreamProvider.family<List<ProblemModel>, ProblemStatus>((ref, status) {
  return ref.watch(problemRepositoryProvider).watchByStatus(status);
});

// Number of problems first-solved today (for daily goal progress)
final todaySolvedCountProvider = Provider<int>((ref) {
  final problems = ref.watch(allProblemsProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final todayNorm = DateTime(now.year, now.month, now.day);
  return problems.where((p) {
    if (p.status != ProblemStatus.solved) return false;
    final d = p.dateSolved;
    return DateTime(d.year, d.month, d.day) == todayNorm;
  }).length;
});

// Last 7 days activity: index 0 = 6 days ago, index 6 = today
final weekActivityProvider = Provider<List<bool>>((ref) {
  final problems = ref.watch(allProblemsProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return List.generate(7, (i) {
    final day = now.subtract(Duration(days: 6 - i));
    final dayNorm = DateTime(day.year, day.month, day.day);
    return problems.any((p) {
      final d = p.dateSolved;
      return p.status == ProblemStatus.solved &&
          DateTime(d.year, d.month, d.day) == dayNorm;
    });
  });
});

// Heatmap data: date (midnight) → solve count, last 365 days
final heatmapDataProvider = Provider<Map<DateTime, int>>((ref) {
  final problems = ref.watch(allProblemsProvider).valueOrNull ?? [];
  final cutoff = DateTime.now().subtract(const Duration(days: 365));
  final result = <DateTime, int>{};
  for (final p in problems) {
    if (p.status != ProblemStatus.solved) continue;
    if (p.dateSolved.isBefore(cutoff)) continue;
    final day = DateTime(p.dateSolved.year, p.dateSolved.month, p.dateSolved.day);
    result[day] = (result[day] ?? 0) + 1;
  }
  return result;
});
