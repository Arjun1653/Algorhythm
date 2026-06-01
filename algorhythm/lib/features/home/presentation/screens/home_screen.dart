import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/difficulty_chip.dart';
import '../../../problem_log/data/models/problem_model.dart';
import '../../../problem_log/presentation/providers/problem_provider.dart';
import '../../../srs/presentation/providers/review_provider.dart';
import '../../../streak/data/models/streak_model.dart';
import '../../../streak/presentation/providers/streak_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    final streakAsync = ref.watch(streakProvider);
    final dueAsync = ref.watch(dueReviewsProvider);
    final recentAsync = ref.watch(allProblemsProvider);
    final weekActivity = ref.watch(weekActivityProvider);
    final todaySolved = ref.watch(todaySolvedCountProvider);
    final dailyGoal = ref.watch(dailyGoalProvider);

    final streak = streakAsync.valueOrNull ??
        (StreakModel()
          ..currentStreak = 0
          ..longestStreak = 0
          ..totalSolved = 0
          ..lastSolvedDate = DateTime(2000));

    final dueCount = dueAsync.valueOrNull?.length ?? 0;
    final recentProblems = (recentAsync.valueOrNull ?? []).take(5).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
          children: [
            _Header(isDark: isDark, text1: text1, text3: text3),
            const SizedBox(height: 18),
            _StreakHero(streak: streak, weekActivity: weekActivity, isDark: isDark),
            const SizedBox(height: 14),
            _TodayProgress(
              todaySolved: todaySolved,
              dailyGoal: dailyGoal,
              isDark: isDark,
            ),
            if (dueCount > 0) ...[
              const SizedBox(height: 14),
              _ReviewBanner(count: dueCount, onTap: () => context.push(AppRoutes.review)),
            ],
            const SizedBox(height: 22),
            _SectionLabel(label: 'Quick stats', isDark: isDark),
            const SizedBox(height: 12),
            _QuickStats(streak: streak, isDark: isDark),
            if (recentProblems.isNotEmpty) ...[
              const SizedBox(height: 22),
              _SectionLabel(label: 'Recently logged', isDark: isDark),
              const SizedBox(height: 12),
              ...recentProblems.map((p) => _RecentItem(
                    problem: p,
                    isDark: isDark,
                    onTap: () => context.push(AppRoutes.problemDetailPath(p.id)),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final bool isDark;
  final Color text1, text3;

  const _Header({required this.isDark, required this.text1, required this.text3});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _dateLabel {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[now.weekday - 1]} · ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_dateLabel,
                  style: AppTextStyles.eyebrow.copyWith(color: text3)),
              const SizedBox(height: 4),
              Text(_greeting,
                  style: AppTextStyles.display24.copyWith(color: text1)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push(AppRoutes.settings),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: surface3,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Icon(Icons.settings_outlined, color: text3, size: 20),
          ),
        ),
      ],
    );
  }
}

// ── Streak hero ────────────────────────────────────────────────────────────

class _StreakHero extends StatelessWidget {
  final StreakModel streak;
  final List<bool> weekActivity;
  final bool isDark;

  const _StreakHero({
    required this.streak,
    required this.weekActivity,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    // Day labels for the last 7 days
    const dayLetters = ['M', 'T', 'W', 'Th', 'F', 'Sa', 'Su'];
    final now = DateTime.now();
    final labels = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return dayLetters[day.weekday - 1];
    });

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: surface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Stack(
        children: [
          // Radial glow
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.accentSoft, Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Icon(Icons.local_fire_department_rounded,
                          color: AppColors.accent, size: 34),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${streak.currentStreak}',
                              style: const TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontWeight: FontWeight.w700,
                                fontSize: 56,
                                height: 0.95,
                                letterSpacing: -2,
                                color: AppColors.darkText1,
                              ).merge(TextStyle(
                                color: text1,
                              )),
                            ),
                            const SizedBox(width: 8),
                            Text('days',
                                style: AppTextStyles.display18
                                    .copyWith(color: text2)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Current streak · best ${streak.longestStreak}',
                          style: AppTextStyles.eyebrow.copyWith(color: text3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final on = weekActivity[i];
                  return Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: on ? AppColors.accent : surface3,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: on
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 15)
                              : Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: text3,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(labels[i],
                          style: AppTextStyles.mono11
                              .copyWith(color: text3, fontSize: 10)),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Today's progress ───────────────────────────────────────────────────────

class _TodayProgress extends StatelessWidget {
  final int todaySolved;
  final int dailyGoal;
  final bool isDark;

  const _TodayProgress({
    required this.todaySolved,
    required this.dailyGoal,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    final done = todaySolved >= dailyGoal;
    final progress = dailyGoal > 0
        ? (todaySolved / dailyGoal).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: done ? AppColors.emeraldSoft : surface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: done
                ? AppColors.emerald.withValues(alpha: 0.28)
                : border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    done
                        ? Icons.check_circle_rounded
                        : Icons.track_changes_rounded,
                    color: done ? AppColors.emerald : AppColors.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    done ? 'Goal complete!' : 'Today\'s goal',
                    style: AppTextStyles.display16.copyWith(
                        color: done ? AppColors.emerald : text1,
                        fontSize: 14.5),
                  ),
                ],
              ),
              Text(
                '$todaySolved / $dailyGoal',
                style: AppTextStyles.mono12.copyWith(
                    color: done ? AppColors.emerald : text2,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: done
                  ? AppColors.emerald.withValues(alpha: 0.2)
                  : border,
              valueColor: AlwaysStoppedAnimation(
                  done ? AppColors.emerald : AppColors.accent),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              done
                  ? 'Great work — keep the streak alive!'
                  : '${dailyGoal - todaySolved} more to hit your daily target',
              style: AppTextStyles.mono11.copyWith(color: text3),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Review banner ──────────────────────────────────────────────────────────

class _ReviewBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _ReviewBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.amberSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.amber.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.schedule_rounded,
                  color: AppColors.amber, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count problem${count == 1 ? '' : 's'} due for review',
                    style: AppTextStyles.display16
                        .copyWith(color: AppColors.amber, fontSize: 14.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Spaced repetition keeps patterns sharp',
                    style: AppTextStyles.mono11
                        .copyWith(color: AppColors.amber.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded,
                color: AppColors.amber, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Quick stats grid ───────────────────────────────────────────────────────

class _QuickStats extends StatelessWidget {
  final StreakModel streak;
  final bool isDark;

  const _QuickStats({required this.streak, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.emerald,
          value: '${streak.totalSolved}',
          label: 'SOLVED',
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.local_fire_department_rounded,
          iconColor: AppColors.accent,
          value: '${streak.currentStreak}',
          label: 'STREAK',
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.emoji_events_rounded,
          iconColor: AppColors.amber,
          value: '${streak.longestStreak}',
          label: 'LONGEST',
          isDark: isDark,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 15, 14, 14),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 19),
            const SizedBox(height: 10),
            Text(value,
                style: AppTextStyles.display22
                    .copyWith(color: text1, letterSpacing: -0.5)),
            const SizedBox(height: 2),
            Text(label,
                style: AppTextStyles.eyebrow
                    .copyWith(color: text3, fontSize: 9.5)),
          ],
        ),
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    return Text(label.toUpperCase(),
        style: AppTextStyles.eyebrow.copyWith(color: text3));
  }
}

// ── Recent problem item ────────────────────────────────────────────────────

class _RecentItem extends StatelessWidget {
  final ProblemModel problem;
  final bool isDark;
  final VoidCallback onTap;

  const _RecentItem({
    required this.problem,
    required this.isDark,
    required this.onTap,
  });

  Color get _statusColor {
    return switch (problem.status) {
      ProblemStatus.solved => AppColors.emerald,
      ProblemStatus.needsReview => AppColors.amber,
      ProblemStatus.attempted ||
      ProblemStatus.unsolved =>
        isDark ? AppColors.darkText3 : AppColors.lightText3,
    };
  }

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final dotColor = _statusColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: dotColor.withValues(alpha: 0.35),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                problem.title,
                style: AppTextStyles.display16
                    .copyWith(color: text1, fontSize: 14.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            DifficultyChip(difficulty: problem.difficulty),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: text3, size: 16),
          ],
        ),
      ),
    );
  }
}
