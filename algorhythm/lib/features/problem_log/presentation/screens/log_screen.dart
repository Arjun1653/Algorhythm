import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/difficulty_chip.dart';
import '../../data/models/problem_model.dart';
import '../providers/problem_provider.dart';
import '../widgets/add_problem_sheet.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  String _query = '';
  String _filter = 'all'; // all | solved | needsReview | attempted

  List<ProblemModel> _applyFilters(List<ProblemModel> all) {
    return all.where((p) {
      final matchesFilter = _filter == 'all' ||
          (_filter == 'solved' && p.status == ProblemStatus.solved) ||
          (_filter == 'needsReview' && p.status == ProblemStatus.needsReview) ||
          (_filter == 'attempted' && p.status == ProblemStatus.attempted);

      if (!matchesFilter) return false;
      if (_query.isEmpty) return true;

      final q = _query.toLowerCase();
      return p.title.toLowerCase().contains(q) ||
          p.topicId.toLowerCase().contains(q) ||
          p.patterns.any((pat) => pat.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final allAsync = ref.watch(allProblemsProvider);

    return Scaffold(
      body: SafeArea(
        child: allAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (all) {
            final filtered = _applyFilters(all);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${all.length} logged',
                          style: AppTextStyles.eyebrow.copyWith(color: text3)),
                      const SizedBox(height: 4),
                      Text('Problem Log',
                          style: AppTextStyles.display28.copyWith(color: text1)),
                      const SizedBox(height: 16),
                      // Search bar
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: surface2,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: border),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Icon(Icons.search_rounded, color: text3, size: 19),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: (v) =>
                                    setState(() => _query = v),
                                style: AppTextStyles.body15
                                    .copyWith(color: text1),
                                decoration: InputDecoration(
                                  hintText: 'Search problems, patterns…',
                                  hintStyle: AppTextStyles.body15
                                      .copyWith(color: text3),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  fillColor: Colors.transparent,
                                  filled: false,
                                ),
                              ),
                            ),
                            if (_query.isNotEmpty) ...[
                              GestureDetector(
                                onTap: () => setState(() => _query = ''),
                                child: Icon(Icons.close_rounded,
                                    color: text3, size: 18),
                              ),
                              const SizedBox(width: 14),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final f in const [
                              ('all', 'All'),
                              ('needsReview', 'Review'),
                              ('solved', 'Solved'),
                              ('attempted', 'Retry'),
                            ])
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _filter = f.$1),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: _filter == f.$1
                                          ? AppColors.accent
                                          : surface2,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _filter == f.$1
                                            ? AppColors.accent
                                            : border,
                                      ),
                                    ),
                                    child: Text(
                                      f.$2,
                                      style: AppTextStyles.display16
                                          .copyWith(
                                        fontSize: 13,
                                        color: _filter == f.$1
                                            ? AppColors.onAccent
                                            : text2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filtered.isEmpty
                      ? _EmptyState(query: _query, isDark: isDark)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => _LogItem(
                            problem: filtered[i],
                            surface2: surface2,
                            surface3: surface3,
                            border: border,
                            text1: text1,
                            text2: text2,
                            text3: text3,
                            onTap: () => context.push(
                                AppRoutes.problemDetailPath(filtered[i].id)),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddSheet(context),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddProblemSheet(),
    );
  }
}

class _LogItem extends StatelessWidget {
  final ProblemModel problem;
  final Color surface2, surface3, border, text1, text2, text3;
  final VoidCallback onTap;

  const _LogItem({
    required this.problem,
    required this.surface2,
    required this.surface3,
    required this.border,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.onTap,
  });

  Color get _statusColor {
    return switch (problem.status) {
      ProblemStatus.solved => AppColors.emerald,
      ProblemStatus.needsReview => AppColors.amber,
      ProblemStatus.attempted => AppColors.darkText3,
      ProblemStatus.unsolved => AppColors.darkText3,
    };
  }

  String get _statusLabel {
    return switch (problem.status) {
      ProblemStatus.solved => 'Solved',
      ProblemStatus.needsReview => 'Review',
      ProblemStatus.attempted => 'Retry',
      ProblemStatus.unsolved => 'Unsolved',
    };
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = _statusColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: dotColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        spreadRadius: 2)
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          problem.title,
                          style: AppTextStyles.display16
                              .copyWith(color: text1, fontSize: 15.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _statusLabel,
                        style: AppTextStyles.mono11.copyWith(
                            color: dotColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      DifficultyChip(difficulty: problem.difficulty),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: surface3,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          problem.platform.name,
                          style:
                              AppTextStyles.mono11.copyWith(color: text2),
                        ),
                      ),
                      if (problem.patterns.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            problem.patterns.first,
                            style: AppTextStyles.mono11
                                .copyWith(color: text3),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final bool isDark;

  const _EmptyState({required this.query, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text3 =
        isDark ? AppColors.darkText3 : AppColors.lightText3;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.list_alt_outlined, size: 56, color: text3),
            const SizedBox(height: 16),
            Text(
              query.isEmpty
                  ? 'Nothing logged yet.\nTap + to add your first problem.'
                  : 'No problems match "$query"',
              style: AppTextStyles.mono13.copyWith(color: text3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
