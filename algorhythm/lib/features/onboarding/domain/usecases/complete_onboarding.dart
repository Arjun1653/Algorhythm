import 'package:shared_preferences/shared_preferences.dart';

import 'package:isar/isar.dart';

import '../../../../core/database/database_initializer.dart';

class CompleteOnboarding {
  final SharedPreferences _prefs;
  final Isar _isar;

  CompleteOnboarding(this._prefs, this._isar);

  Future<void> call({
    required AppMode mode,
    required ExperienceLevel level,
    required int dailyGoal,
  }) async {
    _prefs.setString('mode', mode.name);
    _prefs.setString('level', level.name);
    _prefs.setInt('daily_goal', dailyGoal);
    _prefs.setBool('onboarding_complete', true);

    final initializer = DatabaseInitializer(_isar);
    await initializer.initializeIfNeeded(isStriverMode: mode == AppMode.striver);
  }
}

enum AppMode { custom, striver }

enum ExperienceLevel { beginner, midLevel, rusty }
