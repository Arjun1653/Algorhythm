import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/difficulty_chip.dart';
import '../../../problem_log/data/models/problem_model.dart';
import '../../../problem_log/data/repositories/problem_repository.dart';
import '../../data/models/topic_model.dart';
import '../providers/roadmap_provider.dart';

class TopicDetailScreen extends ConsumerStatefulWidget {
  final String topicId;

  const TopicDetailScreen({super.key, required this.topicId});

  @override
  ConsumerState<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends ConsumerState<TopicDetailScreen> {
  int _tab = 0; // 0 = Cheatsheet, 1 = My Problems
  List<ProblemModel>? _problems;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final isar = ref.read(isarProvider);
    final repo = ProblemRepository(isar);
    final problems = await repo.getByTopic(widget.topicId);
    problems.sort((a, b) => b.dateSolved.compareTo(a.dateSolved));
    if (mounted) {
      setState(() {
        _problems = problems;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    // Resolve topic metadata from the provider — no direct Isar query needed
    final topicsAsync = ref.watch(customTopicsProvider);
    final allTopics = topicsAsync.valueOrNull ?? [];
    final matching = allTopics.where((t) => t.topicId == widget.topicId);
    final topic = matching.isNotEmpty ? matching.first : null;

    final topicName = topic?.name ?? widget.topicId;
    final problems = _problems ?? [];
    final solvedCount =
        problems.where((p) => p.status == ProblemStatus.solved).length;
    final totalEstimated = topic?.estimatedProblems ?? 0;
    final pct = totalEstimated > 0
        ? (solvedCount / totalEstimated * 100).round().clamp(0, 100)
        : 0;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: surface2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border),
                      ),
                      child: Icon(Icons.chevron_left_rounded,
                          color: text2, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOPIC',
                            style: AppTextStyles.eyebrow.copyWith(color: text3)),
                        const SizedBox(height: 2),
                        Text(
                          topicName,
                          style: AppTextStyles.display18.copyWith(color: text1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Progress card
            if (!_loading && totalEstimated > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                  decoration: BoxDecoration(
                    color: surface2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$solvedCount / $totalEstimated problems solved',
                            style: AppTextStyles.mono11.copyWith(
                                color: text2, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '$pct%',
                            style: AppTextStyles.mono12.copyWith(
                              color: pct == 100
                                  ? AppColors.emerald
                                  : AppColors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 7,
                          backgroundColor: border,
                          valueColor: AlwaysStoppedAnimation(pct == 100
                              ? AppColors.emerald
                              : AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Tab bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: _TabBar(
                active: _tab,
                onChange: (i) => setState(() => _tab = i),
                isDark: isDark,
              ),
            ),

            // Tab content
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _tab == 0
                          ? _CheatsheetTab(
                              key: const ValueKey('cheatsheet'),
                              topic: topic,
                              isDark: isDark,
                            )
                          : _ProblemsTab(
                              key: const ValueKey('problems'),
                              problems: problems,
                              isDark: isDark,
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab bar ────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final int active;
  final ValueChanged<int> onChange;
  final bool isDark;

  const _TabBar(
      {required this.active, required this.onChange, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          _TabBtn(
              label: 'Cheatsheet',
              isActive: active == 0,
              onTap: () => onChange(0),
              surface3: surface3,
              border: border,
              text1: text1,
              text3: text3),
          _TabBtn(
              label: 'My Problems',
              isActive: active == 1,
              onTap: () => onChange(1),
              surface3: surface3,
              border: border,
              text1: text1,
              text3: text3),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color surface3, border, text1, text3;

  const _TabBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.surface3,
    required this.border,
    required this.text1,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? surface3 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isActive ? border : Colors.transparent),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.display16
                  .copyWith(fontSize: 13, color: isActive ? text1 : text3),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Cheatsheet tab ─────────────────────────────────────────────────────────

class _CheatsheetTab extends StatelessWidget {
  final TopicModel? topic;
  final bool isDark;

  const _CheatsheetTab(
      {super.key, required this.topic, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      children: [
        if (topic?.description != null && topic!.description.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surface2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONCEPT',
                    style: AppTextStyles.eyebrow.copyWith(color: text3)),
                const SizedBox(height: 10),
                Text(topic!.description,
                    style: AppTextStyles.body14.copyWith(color: text1, height: 1.7)),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('KEY PATTERNS',
                  style: AppTextStyles.eyebrow.copyWith(color: text3)),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Coming soon',
                    style: AppTextStyles.chip
                        .copyWith(color: AppColors.accent)),
              ),
              const SizedBox(height: 10),
              Text(
                'Pattern cheatsheets with code snippets, complexity analysis, '
                'and common mistakes are being authored for each topic.',
                style: AppTextStyles.mono11.copyWith(color: text2, height: 1.65),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Problems tab ───────────────────────────────────────────────────────────

class _ProblemsTab extends StatelessWidget {
  final List<ProblemModel> problems;
  final bool isDark;

  const _ProblemsTab(
      {super.key, required this.problems, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    if (problems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.list_alt_outlined, size: 52, color: text3),
              const SizedBox(height: 14),
              Text(
                'No problems logged for this topic yet.\nTap + on the Log tab to add one.',
                textAlign: TextAlign.center,
                style: AppTextStyles.mono13.copyWith(color: text3, height: 1.6),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      itemCount: problems.length,
      itemBuilder: (_, i) => _ProblemRow(
        problem: problems[i],
        isDark: isDark,
        onTap: () =>
            context.push(AppRoutes.problemDetailPath(problems[i].id)),
      ),
    );
  }
}

class _ProblemRow extends StatelessWidget {
  final ProblemModel problem;
  final bool isDark;
  final VoidCallback onTap;

  const _ProblemRow(
      {required this.problem, required this.isDark, required this.onTap});

  Color get _dot => switch (problem.status) {
        ProblemStatus.solved => AppColors.emerald,
        ProblemStatus.needsReview => AppColors.amber,
        ProblemStatus.attempted || ProblemStatus.unsolved => AppColors.darkText3,
      };

  String get _label => switch (problem.status) {
        ProblemStatus.solved => 'Solved',
        ProblemStatus.needsReview => 'Review',
        ProblemStatus.attempted => 'Retry',
        ProblemStatus.unsolved => 'Not yet',
      };

  @override
  Widget build(BuildContext context) {
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final dot = _dot;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
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
                color: dot,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: dot.withValues(alpha: 0.35),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
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
                              .copyWith(color: text1, fontSize: 14.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_label,
                          style: AppTextStyles.mono11.copyWith(
                              color: dot, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      DifficultyChip(difficulty: problem.difficulty),
                      if (problem.patterns.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            problem.patterns.first,
                            style: AppTextStyles.mono11.copyWith(color: text3),
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
