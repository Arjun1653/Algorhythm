import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/complete_onboarding.dart';

class OnboardingState {
  final int step;
  final AppMode mode;
  final ExperienceLevel level;
  final int dailyGoal;

  const OnboardingState({
    this.step = 0,
    this.mode = AppMode.custom,
    this.level = ExperienceLevel.beginner,
    this.dailyGoal = 2,
  });

  OnboardingState copyWith({
    int? step,
    AppMode? mode,
    ExperienceLevel? level,
    int? dailyGoal,
  }) =>
      OnboardingState(
        step: step ?? this.step,
        mode: mode ?? this.mode,
        level: level ?? this.level,
        dailyGoal: dailyGoal ?? this.dailyGoal,
      );
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setMode(AppMode mode) => state = state.copyWith(mode: mode);
  void setLevel(ExperienceLevel level) => state = state.copyWith(level: level);
  void setDailyGoal(int goal) => state = state.copyWith(dailyGoal: goal);

  void nextStep() {
    if (state.step < 2) state = state.copyWith(step: state.step + 1);
  }

  void prevStep() {
    if (state.step > 0) state = state.copyWith(step: state.step - 1);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (_) => OnboardingNotifier(),
);
