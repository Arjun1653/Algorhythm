import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences_provider.dart';

// ── Dark mode ──────────────────────────────────────────────────────────────

class DarkModeNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  DarkModeNotifier(this._prefs) : super(_prefs.getBool('dark_mode') ?? true);

  void set(bool value) {
    state = value;
    _prefs.setBool('dark_mode', value);
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref.watch(sharedPreferencesProvider));
});

// ── Daily goal ─────────────────────────────────────────────────────────────

class DailyGoalNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  DailyGoalNotifier(this._prefs) : super(_prefs.getInt('daily_goal') ?? 2);

  void set(int value) {
    state = value;
    _prefs.setInt('daily_goal', value);
  }
}

final dailyGoalProvider = StateNotifierProvider<DailyGoalNotifier, int>((ref) {
  return DailyGoalNotifier(ref.watch(sharedPreferencesProvider));
});

// ── App mode (striver / custom) ────────────────────────────────────────────

class AppModeNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;

  AppModeNotifier(this._prefs)
      : super(_prefs.getString('mode') ?? 'custom');

  void set(String mode) {
    state = mode;
    _prefs.setString('mode', mode);
  }
}

final appModeProvider = StateNotifierProvider<AppModeNotifier, String>((ref) {
  return AppModeNotifier(ref.watch(sharedPreferencesProvider));
});
