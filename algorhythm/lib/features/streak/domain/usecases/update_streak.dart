import 'package:isar/isar.dart';

import '../../data/models/streak_model.dart';

class UpdateStreak {
  final Isar _isar;

  UpdateStreak(this._isar);

  Future<void> call() async {
    final streak = (await _isar.streakModels.get(1)) ??
        (StreakModel()
          ..id = 1
          ..currentStreak = 0
          ..longestStreak = 0
          ..totalSolved = 0
          ..lastSolvedDate = DateTime(2000));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = streak.lastSolvedDate;
    final lastDay = DateTime(last.year, last.month, last.day);

    if (lastDay == today) {
      // Already counted today — just increment total
      streak.totalSolved += 1;
    } else if (lastDay == today.subtract(const Duration(days: 1))) {
      // Consecutive day
      streak.currentStreak += 1;
      streak.totalSolved += 1;
    } else {
      // Gap — reset streak
      streak.currentStreak = 1;
      streak.totalSolved += 1;
    }

    streak.lastSolvedDate = now;

    if (streak.currentStreak > streak.longestStreak) {
      streak.longestStreak = streak.currentStreak;
    }

    await _isar.writeTxn(() async {
      await _isar.streakModels.put(streak);
    });
  }
}
