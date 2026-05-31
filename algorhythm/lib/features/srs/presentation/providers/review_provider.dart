import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/problem_log/data/models/problem_model.dart';
import '../../../../features/problem_log/data/repositories/problem_repository.dart';
import '../../../../core/database/database_provider.dart';

final dueReviewsProvider = StreamProvider<List<ProblemModel>>((ref) {
  final isar = ref.watch(isarProvider);
  return ProblemRepository(isar).watchDueForReview();
});
