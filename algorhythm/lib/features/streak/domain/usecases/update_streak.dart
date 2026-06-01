import 'package:isar/isar.dart';

import '../../data/models/streak_model.dart';

class UpdateStreak {
  final Isar _isar;

  UpdateStreak(this._isar);

  // isNewSolve=true for first-time logs; false for re-reviews of existing problems.
  Future<void> call({bool isNewSolve = true}) async {
    await _isar.writeTxn(() async {
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

      if (isNewSolve) {
        streak.totalSolved += 1;
      }

      if (lastDay != today) {
        if (lastDay == today.subtract(const Duration(days: 1))) {
          streak.currentStreak += 1;
        } else {
          streak.currentStreak = 1;
        }
        streak.lastSolvedDate = now;
        if (streak.currentStreak > streak.longestStreak) {
          streak.longestStreak = streak.currentStreak;
        }
      }

      await _isar.streakModels.put(streak);
    });
  }
}
