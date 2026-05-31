import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/models/streak_model.dart';

final streakProvider = StreamProvider<StreakModel>((ref) {
  final isar = ref.watch(isarProvider);
  return isar.streakModels.watchObject(1, fireImmediately: true).map(
    (s) =>
        s ??
        (StreakModel()
          ..id = 1
          ..currentStreak = 0
          ..longestStreak = 0
          ..totalSolved = 0
          ..lastSolvedDate = DateTime(2000)),
  );
});
