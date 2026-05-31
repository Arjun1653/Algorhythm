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
