import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/topic_model.dart';
import '../providers/roadmap_provider.dart';

class RoadmapScreen extends ConsumerStatefulWidget {
  const RoadmapScreen({super.key});

  @override
  ConsumerState<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends ConsumerState<RoadmapScreen> {
  bool _isStriverMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR PATH',
                      style: AppTextStyles.eyebrow.copyWith(color: text3)),
                  const SizedBox(height: 4),
                  Text('Roadmap',
                      style: AppTextStyles.display28.copyWith(color: text1)),
                  const SizedBox(height: 18),
                  // Mode toggle
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: surface2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        _ToggleBtn(
                          label: 'Custom',
                          isActive: !_isStriverMode,
                          onTap: () =>
                              setState(() => _isStriverMode = false),
                          isDark: isDark,
                          accentColor: text1,
                        ),
                        _ToggleBtn(
                          label: 'Striver A2Z',
                          isActive: _isStriverMode,
                          onTap: () =>
                              setState(() => _isStriverMode = true),
                          isDark: isDark,
                          accentColor: AppColors.accent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _isStriverMode
                    ? _StriverView(key: const ValueKey('striver'))
                    : _CustomView(
                        key: const ValueKey('custom'),
                        onTopicTap: (topicId) =>
                            context.push(AppRoutes.topicDetailPath(topicId)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mode toggle button ─────────────────────────────────────────────────────

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;
  final Color accentColor;

  const _ToggleBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final surface3 =
        isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? surface3 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isActive ? border : Colors.transparent),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.display16.copyWith(
                fontSize: 13,
                color: isActive ? accentColor : text3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Custom roadmap view ────────────────────────────────────────────────────

class _CustomView extends ConsumerWidget {
  final ValueChanged<String> onTopicTap;

  const _CustomView({super.key, required this.onTopicTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final topicsAsync = ref.watch(customTopicsProvider);

    return topicsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (topics) {
        if (topics.isEmpty) {
          return Center(
            child: Text('No topics yet',
                style: AppTextStyles.mono13.copyWith(color: text3)),
          );
        }

        final totalSolved = 0; // computed from problem data in Stage 2
        final totalAll =
            topics.fold(0, (sum, t) => sum + t.estimatedProblems);

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          children: [
            // Overall progress
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalAll > 0 ? totalSolved / totalAll : 0,
                      minHeight: 8,
                      backgroundColor: border,
                      valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('$totalSolved/$totalAll',
                    style: AppTextStyles.mono12.copyWith(
                        color: text2, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${topics.where((t) => t.state == TopicState.done).length} of ${topics.length} topics mastered',
              style: AppTextStyles.mono11.copyWith(color: text3),
            ),
            const SizedBox(height: 22),
            ...topics.asMap().entries.map((e) => _RoadmapNode(
                  topic: e.value,
                  index: e.key,
                  isLast: e.key == topics.length - 1,
                  onTap: () => onTopicTap(e.value.topicId),
                  isDark: isDark,
                )),
          ],
        );
      },
    );
  }
}

class _RoadmapNode extends StatelessWidget {
  final TopicModel topic;
  final int index;
  final bool isLast;
  final VoidCallback onTap;
  final bool isDark;

  const _RoadmapNode({
    required this.topic,
    required this.index,
    required this.isLast,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final locked = topic.state == TopicState.locked;
    final done = topic.state == TopicState.done;
    final active = topic.state == TopicState.active;

    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface2 =
        isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 =
        isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final borderStrong =
        isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong;

    final nodeColor = done
        ? AppColors.emerald
        : active
            ? AppColors.accent
            : surface3;
    final nodeTextColor =
        (done || active) ? Colors.white : text3;

    return Opacity(
      opacity: locked ? 0.52 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rail
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    borderRadius: BorderRadius.circular(12),
                    border: (!done && !active)
                        ? Border.all(color: borderStrong)
                        : null,
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 17)
                        : locked
                            ? Icon(Icons.lock_outline_rounded,
                                color: text3, size: 15)
                            : Text(
                                '${index + 1}',
                                style: AppTextStyles.display16.copyWith(
                                    color: nodeTextColor, fontSize: 13),
                              ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 26,
                    margin: const EdgeInsets.only(top: 4),
                    color: border,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: GestureDetector(
              onTap: locked ? null : onTap,
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface2,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: active ? AppColors.accentLine : border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(topic.name,
                              style: AppTextStyles.display16
                                  .copyWith(color: text1)),
                        ),
                        if (active)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accentSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Active',
                                style: AppTextStyles.chip
                                    .copyWith(color: AppColors.accent)),
                          )
                        else if (done)
                          const Icon(Icons.check_rounded,
                              color: AppColors.emerald, size: 18)
                        else if (!locked)
                          Icon(Icons.chevron_right_rounded,
                              color: text3, size: 16)
                        else
                          Icon(Icons.lock_outline_rounded,
                              color: text3, size: 16),
                      ],
                    ),
                    if (!locked) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: 0,
                                minHeight: 6,
                                backgroundColor: border,
                                valueColor: AlwaysStoppedAnimation(
                                    done
                                        ? AppColors.emerald
                                        : AppColors.accent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('0%',
                              style: AppTextStyles.mono11.copyWith(
                                  color: text2,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Text(
                        '0 / ${topic.estimatedProblems} problems'
                        '${topic.state == TopicState.unlocked ? ' · ready to start' : ''}',
                        style:
                            AppTextStyles.mono11.copyWith(color: text3),
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      Text(
                        '${topic.estimatedProblems} problems · complete previous topic to unlock',
                        style:
                            AppTextStyles.mono11.copyWith(color: text3),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Striver roadmap view ───────────────────────────────────────────────────

class _StriverView extends ConsumerWidget {
  const _StriverView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface2 =
        isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 =
        isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final sectionsAsync = ref.watch(striverSectionsProvider);

    return sectionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (sections) {
        final totalSolved =
            sections.fold(0, (sum, s) => sum + (s['solved'] as int));
        const totalAll = 474;
        final pct =
            (totalSolved / totalAll * 100).round();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          children: [
            // Overall progress card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: AppTextStyles.display28
                                  .copyWith(color: text1),
                              children: [
                                TextSpan(text: '$totalSolved'),
                                TextSpan(
                                  text: ' / $totalAll',
                                  style: AppTextStyles.display18.copyWith(
                                      color: text3,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Striver A2Z · 18 sections',
                              style: AppTextStyles.mono11
                                  .copyWith(color: text3)),
                        ],
                      ),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.accentSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$pct%',
                            style: AppTextStyles.display16.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalSolved / totalAll,
                      minHeight: 8,
                      backgroundColor: border,
                      valueColor: const AlwaysStoppedAnimation(
                          AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _DiffDot(color: AppColors.emerald,
                          label: '152 Easy'),
                      const SizedBox(width: 16),
                      _DiffDot(color: AppColors.amber,
                          label: '186 Medium'),
                      const SizedBox(width: 16),
                      _DiffDot(color: AppColors.red,
                          label: '136 Hard'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ...sections.asMap().entries.map((e) {
              final s = e.value;
              final solved = s['solved'] as int;
              final total = s['total'] as int;
              final pctSection =
                  total > 0 ? (solved / total * 100).round() : 0;
              final isDone = pctSection == 100;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                decoration: BoxDecoration(
                  color: surface2,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDone
                        ? AppColors.emerald.withValues(alpha: 0.28)
                        : border,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppColors.emerald
                                : surface3,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 15)
                                : Text(
                                    '${e.key + 1}',
                                    style: AppTextStyles.display16
                                        .copyWith(
                                            color: text3,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            s['name'] as String,
                            style: AppTextStyles.display16
                                .copyWith(color: text1, fontSize: 14.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: text3, size: 16),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: total > 0 ? solved / total : 0,
                              minHeight: 6,
                              backgroundColor: border,
                              valueColor: AlwaysStoppedAnimation(
                                  isDone
                                      ? AppColors.emerald
                                      : AppColors.accent),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$solved / $total',
                          style: AppTextStyles.mono11.copyWith(
                              color: text2,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _DiffDot extends StatelessWidget {
  final Color color;
  final String label;

  const _DiffDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: AppTextStyles.mono11.copyWith(color: text3)),
      ],
    );
  }
}
