import 'package:isar/isar.dart';

part 'streak_model.g.dart';

@collection
class StreakModel {
  Id id = 1; // singleton — only one row ever

  late int currentStreak;
  late int longestStreak;
  late int totalSolved;
  late DateTime lastSolvedDate;
}
