import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../heatmap/domain/usecases/build_heatmap_data.dart';
import '../../../heatmap/presentation/widgets/heatmap_widget.dart';
import '../../../problem_log/presentation/providers/problem_provider.dart';
import '../../../roadmap/presentation/providers/roadmap_provider.dart';
import '../../../streak/data/models/streak_model.dart';
import '../../../streak/presentation/providers/streak_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    final streakAsync = ref.watch(streakProvider);
    final heatmapData = ref.watch(heatmapDataProvider);
    final masteryList = ref.watch(topicMasteryProvider);

    final streak = streakAsync.valueOrNull ??
        (StreakModel()
          ..currentStreak = 0
          ..longestStreak = 0
          ..totalSolved = 0
          ..lastSolvedDate = DateTime(2000));

    final hd = BuildHeatmapData().call(heatmapData);
    final focusAreas =
        masteryList.where((m) => (m['pct'] as int) < 45).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
          children: [
            Text('INSIGHTS',
                style: AppTextStyles.eyebrow.copyWith(color: text3)),
            const SizedBox(height: 4),
            Text('Analytics',
                style: AppTextStyles.display28.copyWith(color: text1)),
            const SizedBox(height: 20),

            // Stats row
            _StatsRow(streak: streak, isDark: isDark),
            const SizedBox(height: 16),

            // Activity / heatmap
            _ActivityCard(hd: hd, isDark: isDark),

            // Topic mastery
            if (masteryList.isNotEmpty) ...[
              const SizedBox(height: 24),
              _SectionHeader(
                label: 'Topic mastery',
                badge: '${masteryList.length} topics',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _MasteryCard(masteryList: masteryList, isDark: isDark),
            ],

            // Focus areas
            if (focusAreas.isNotEmpty) ...[
              const SizedBox(height: 24),
              _SectionHeader(label: 'Focus areas', isDark: isDark),
              const SizedBox(height: 12),
              ...focusAreas.map((m) => _FocusCard(
                    m: m,
                    isDark: isDark,
                    onTap: () => context
                        .push(AppRoutes.topicDetailPath(m['topicId'] as String)),
                  )),
            ],

            if (masteryList.isEmpty) ...[
              const SizedBox(height: 40),
              _EmptyState(isDark: isDark),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Stats row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final StreakModel streak;
  final bool isDark;

  const _StatsRow({required this.streak, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniStat(
            value: '${streak.totalSolved}',
            label: 'TOTAL',
            color: AppColors.emerald,
            isDark: isDark),
        const SizedBox(width: 10),
        _MiniStat(
            value: '${streak.currentStreak}d',
            label: 'STREAK',
            color: AppColors.accent,
            isDark: isDark),
        const SizedBox(width: 10),
        _MiniStat(
            value: '${streak.longestStreak}d',
            label: 'BEST',
            color: AppColors.amber,
            isDark: isDark),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.color,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_iconFor(label), color: color, size: 18),
            const SizedBox(height: 8),
            Text(value,
                style: AppTextStyles.display20
                    .copyWith(color: text1, letterSpacing: -0.5)),
            const SizedBox(height: 2),
            Text(label,
                style:
                    AppTextStyles.eyebrow.copyWith(color: text3, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String label) {
    return switch (label) {
      'STREAK' => Icons.local_fire_department_rounded,
      'BEST' => Icons.emoji_events_rounded,
      _ => Icons.check_circle_outline_rounded,
    };
  }
}

// ── Activity card (heatmap) ────────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  final HeatmapData hd;
  final bool isDark;

  const _ActivityCard({required this.hd, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity',
                      style:
                          AppTextStyles.display16.copyWith(color: text1)),
                  const SizedBox(height: 3),
                  Text(
                    '${hd.totalActiveDays} active days · last 12 months',
                    style: AppTextStyles.mono11.copyWith(color: text3),
                  ),
                ],
              ),
              const Icon(Icons.calendar_today_rounded,
                  color: AppColors.accent, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          HeatmapWidget(data: hd.counts),
        ],
      ),
    );
  }
}

// ── Topic mastery card ────────────────────────────────────────────────────

class _MasteryCard extends StatelessWidget {
  final List<Map<String, dynamic>> masteryList;
  final bool isDark;

  const _MasteryCard({required this.masteryList, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
      decoration: BoxDecoration(
        color: surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: masteryList
            .map((m) => _MasteryBar(m: m, isDark: isDark))
            .toList(),
      ),
    );
  }
}

class _MasteryBar extends StatelessWidget {
  final Map<String, dynamic> m;
  final bool isDark;

  const _MasteryBar({required this.m, required this.isDark});

  Color _color(int pct) {
    if (pct >= 70) return AppColors.emerald;
    if (pct >= 40) return AppColors.amber;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;

    final pct = m['pct'] as int;
    final color = _color(pct);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(m['name'] as String,
                  style: AppTextStyles.display16
                      .copyWith(color: text1, fontSize: 14)),
              Text('$pct%',
                  style: AppTextStyles.mono12.copyWith(
                      color: color, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 7,
              backgroundColor: border,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Focus area card ────────────────────────────────────────────────────────

class _FocusCard extends StatelessWidget {
  final Map<String, dynamic> m;
  final bool isDark;
  final VoidCallback onTap;

  const _FocusCard({
    required this.m,
    required this.isDark,
    required this.onTap,
  });

  Color _color(int pct) {
    if (pct >= 70) return AppColors.emerald;
    if (pct >= 40) return AppColors.amber;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    final pct = m['pct'] as int;
    final color = _color(pct);
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(Icons.warning_amber_rounded, color: color, size: 20),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m['name'] as String,
                      style: AppTextStyles.display16
                          .copyWith(color: text1, fontSize: 14.5)),
                  const SizedBox(height: 3),
                  Text(
                    '$pct% mastery · '
                    '${pct < 30 ? 'needs focused practice' : 'review recommended'}',
                    style: AppTextStyles.mono11.copyWith(color: text2),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: color, size: 19),
          ],
        ),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final String? badge;
  final bool isDark;

  const _SectionHeader({
    required this.label,
    this.badge,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label.toUpperCase(),
            style: AppTextStyles.eyebrow.copyWith(color: text3)),
        if (badge != null)
          Text(badge!,
              style: AppTextStyles.mono11.copyWith(color: text3)),
      ],
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart_rounded, size: 52, color: text3),
          const SizedBox(height: 14),
          Text(
            'Log problems to see\nyour analytics here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.mono13.copyWith(color: text3, height: 1.6),
          ),
        ],
      ),
    );
  }
}
