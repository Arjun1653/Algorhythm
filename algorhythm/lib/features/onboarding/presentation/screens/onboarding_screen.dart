import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            if (state.step == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.local_fire_department_rounded,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AlgoRhythm',
                            style: AppTextStyles.display20.copyWith(color: text1)),
                        Text('Your personal DSA coach',
                            style: AppTextStyles.mono11.copyWith(color: text3)),
                      ],
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: notifier.prevStep,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_left_rounded, color: text2),
                        Text('Back',
                            style: AppTextStyles.display16.copyWith(color: text2)),
                      ],
                    ),
                  ),
                ),
              ),

            // Step content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: KeyedSubtree(
                    key: ValueKey(state.step),
                    child: switch (state.step) {
                      0 => _StepMode(state: state, notifier: notifier),
                      1 => _StepLevel(state: state, notifier: notifier),
                      _ => _StepGoal(state: state, notifier: notifier),
                    },
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  _StepDots(total: 3, current: state.step),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => _handleNext(context, ref, state),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.step < 2 ? 'Continue' : 'Start practicing',
                            style: AppTextStyles.display16
                                .copyWith(color: AppColors.onAccent),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded,
                              color: AppColors.onAccent, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (state.step == 0) ...[
                    const SizedBox(height: 14),
                    Text('No account needed · fully offline · always free',
                        style: AppTextStyles.mono11.copyWith(color: text3),
                        textAlign: TextAlign.center),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNext(
      BuildContext context, WidgetRef ref, OnboardingState state) async {
    if (state.step < 2) {
      ref.read(onboardingProvider.notifier).nextStep();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final isar = ref.read(isarProvider);
      await CompleteOnboarding(prefs, isar).call(
        mode: state.mode,
        level: state.level,
        dailyGoal: state.dailyGoal,
      );
      if (context.mounted) context.go(AppRoutes.home);
    }
  }
}

// ── Step Dots ──────────────────────────────────────────────────────────────

class _StepDots extends StatelessWidget {
  final int total;
  final int current;

  const _StepDots({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isActive ? 22 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.darkSurface3,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ── Step 0: Mode ───────────────────────────────────────────────────────────

class _StepMode extends StatelessWidget {
  final OnboardingState state;
  final OnboardingNotifier notifier;

  const _StepMode({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('STEP 1 OF 3',
            style: AppTextStyles.eyebrow.copyWith(color: AppColors.accent)),
        const SizedBox(height: 8),
        Text('Choose your path',
            style: AppTextStyles.display28.copyWith(color: text1)),
        const SizedBox(height: 6),
        Text(
          'Both modes use the same SRS engine. You can switch anytime from Settings.',
          style: AppTextStyles.body14.copyWith(color: text2),
        ),
        const SizedBox(height: 24),
        _ModeCard(
          id: AppMode.striver,
          title: 'Striver Mode',
          subtitle: 'Recommended for beginners',
          icon: Icons.layers_rounded,
          features: const [
            '474 problems pre-loaded (A2Z sheet)',
            'Battle-tested linear sequence',
            'No decision fatigue — just follow the path',
          ],
          selected: state.mode,
          onSelect: notifier.setMode,
        ),
        _ModeCard(
          id: AppMode.custom,
          title: 'Custom Mode',
          subtitle: 'For self-directed learners',
          icon: Icons.adjust_rounded,
          features: const [
            'Search from 900+ problems across 8 sources',
            'Build your own roadmap at your own pace',
            'Mix LeetCode, Codeforces, GFG and more',
          ],
          selected: state.mode,
          onSelect: notifier.setMode,
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final AppMode id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> features;
  final AppMode selected;
  final ValueChanged<AppMode> onSelect;

  const _ModeCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.features,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isOn = selected == id;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: () => onSelect(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isOn ? AppColors.accentSoft : surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isOn ? AppColors.accentLine : border,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isOn ? AppColors.accent : surface3,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon,
                      color: isOn ? Colors.white : text2, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style:
                              AppTextStyles.display16.copyWith(color: text1)),
                      Text(subtitle,
                          style:
                              AppTextStyles.mono11.copyWith(color: text2)),
                    ],
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOn ? AppColors.accent : Colors.transparent,
                    border: Border.all(
                      color: isOn ? AppColors.accent : text3,
                      width: 2,
                    ),
                  ),
                  child: isOn
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 13)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Row(
                    children: [
                      Icon(Icons.check_rounded,
                          size: 14,
                          color: isOn ? AppColors.accent : text3),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(f,
                            style:
                                AppTextStyles.mono11.copyWith(color: text2)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Level ──────────────────────────────────────────────────────────

class _StepLevel extends StatelessWidget {
  final OnboardingState state;
  final OnboardingNotifier notifier;

  const _StepLevel({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final hint = switch (state.level) {
      ExperienceLevel.beginner =>
        "We'll start you from easy problems and gradually unlock harder ones as your mastery grows.",
      ExperienceLevel.midLevel =>
        "We'll skip trivials and surface medium/hard problems earlier. Focus areas based on gaps.",
      ExperienceLevel.rusty =>
        "We'll prioritize topics you haven't touched recently using recency-weighted mastery scores.",
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('STEP 2 OF 3',
            style: AppTextStyles.eyebrow.copyWith(color: AppColors.accent)),
        const SizedBox(height: 8),
        Text('Your current level',
            style: AppTextStyles.display28.copyWith(color: text1)),
        const SizedBox(height: 6),
        Text(
          'Calibrates your daily challenge difficulty and weak area detection.',
          style: AppTextStyles.body14.copyWith(color: text2),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _LevelCard(
              id: ExperienceLevel.beginner,
              emoji: '🌱',
              label: 'Beginner',
              desc: 'New to DSA\nor CS basics',
              selected: state.level,
              onSelect: notifier.setLevel,
            ),
            const SizedBox(width: 10),
            _LevelCard(
              id: ExperienceLevel.midLevel,
              emoji: '⚡',
              label: 'Mid-level',
              desc: 'Solved 50+\nproblems before',
              selected: state.level,
              onSelect: notifier.setLevel,
            ),
            const SizedBox(width: 10),
            _LevelCard(
              id: ExperienceLevel.rusty,
              emoji: '🔧',
              label: 'Rusty',
              desc: 'Know the basics,\nneed revision',
              selected: state.level,
              onSelect: notifier.setLevel,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Text(hint,
              style: AppTextStyles.mono12.copyWith(color: text2)),
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final ExperienceLevel id;
  final String emoji;
  final String label;
  final String desc;
  final ExperienceLevel selected;
  final ValueChanged<ExperienceLevel> onSelect;

  const _LevelCard({
    required this.id,
    required this.emoji,
    required this.label,
    required this.desc,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isOn = selected == id;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          decoration: BoxDecoration(
            color: isOn ? AppColors.accentSoft : surface2,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isOn ? AppColors.accentLine : border,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.display16.copyWith(
                    color: isOn ? AppColors.accent : text1,
                    fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                desc,
                style: AppTextStyles.mono11.copyWith(color: text3),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step 2: Goal ──────────────────────────────────────────────────────────

class _StepGoal extends StatelessWidget {
  final OnboardingState state;
  final OnboardingNotifier notifier;

  const _StepGoal({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;

    final totalProblems = state.mode == AppMode.striver ? 474 : 150;
    final days = (totalProblems / state.dailyGoal).ceil();
    final listName =
        state.mode == AppMode.striver ? 'Striver A2Z' : 'NeetCode 150';
    final completionHint = days <= 90
        ? "That's less than 3 months. Totally doable."
        : days <= 180
            ? 'Steady pace — keep your streak alive.'
            : 'Slow and steady. Any daily progress beats zero.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('STEP 3 OF 3',
            style: AppTextStyles.eyebrow.copyWith(color: AppColors.accent)),
        const SizedBox(height: 8),
        Text('Daily target',
            style: AppTextStyles.display28.copyWith(color: text1)),
        const SizedBox(height: 6),
        Text(
          'Be realistic — a streak of 1 problem/day beats a burnout sprint every time.',
          style: AppTextStyles.body14.copyWith(color: text2),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            for (final entry in const [(1, 'Light'), (2, 'Steady'), (3, 'Focused'), (5, 'Grind')]) ...[
              _GoalCard(
                n: entry.$1,
                label: entry.$2,
                selected: state.dailyGoal,
                onSelect: notifier.setDailyGoal,
              ),
              if (entry.$1 != 5) const SizedBox(width: 10),
            ],
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.emeraldSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.emerald.withValues(alpha: 0.24)),
          ),
          child: Row(
            children: [
              const Icon(Icons.adjust_rounded,
                  color: AppColors.emerald, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.mono12
                        .copyWith(color: AppColors.emerald),
                    children: [
                      const TextSpan(text: 'At '),
                      TextSpan(
                        text:
                            '${state.dailyGoal} problem${state.dailyGoal > 1 ? 's' : ''}/day',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                          text:
                              " you'll finish $listName in ~"),
                      TextSpan(
                        text: '$days days',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: '. $completionHint'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final int n;
  final String label;
  final int selected;
  final ValueChanged<int> onSelect;

  const _GoalCard({
    required this.n,
    required this.label,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isOn = selected == n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(n),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            color: isOn ? AppColors.accent : surface2,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isOn ? Colors.transparent : border,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$n',
                style: AppTextStyles.display28.copyWith(
                  color: isOn ? AppColors.onAccent : text2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: AppTextStyles.mono11.copyWith(
                  color: isOn
                      ? AppColors.onAccent.withValues(alpha: 0.8)
                      : text2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
