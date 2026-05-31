import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/confidence_stars.dart';
import '../../../../shared/widgets/difficulty_chip.dart';
import '../../../srs/presentation/widgets/review_modal.dart';
import '../../data/models/review_entry_model.dart';
import '../../data/models/problem_model.dart';
import '../../data/repositories/problem_repository.dart';
import '../../../../core/database/database_provider.dart';

class ProblemDetailScreen extends ConsumerStatefulWidget {
  final int problemId;

  const ProblemDetailScreen({super.key, required this.problemId});

  @override
  ConsumerState<ProblemDetailScreen> createState() =>
      _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends ConsumerState<ProblemDetailScreen> {
  ProblemModel? _problem;
  bool _loading = true;
  bool _editingNotes = false;
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ProblemRepository(ref.read(isarProvider));
    final p = await repo.getById(widget.problemId);
    if (mounted) {
      setState(() {
        _problem = p;
        _notesCtrl.text = p?.notes ?? '';
        _loading = false;
      });
    }
  }

  Future<void> _saveNotes() async {
    final p = _problem;
    if (p == null) return;
    p.notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();
    final repo = ProblemRepository(ref.read(isarProvider));
    await repo.updateProblem(p);
    setState(() => _editingNotes = false);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete problem?'),
        content: const Text('This will remove all review history too.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete',
                  style: TextStyle(color: AppColors.red))),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final repo = ProblemRepository(ref.read(isarProvider));
    await repo.deleteProblem(widget.problemId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    if (_loading) {
      return Scaffold(
          backgroundColor: bg,
          body: const Center(child: CircularProgressIndicator()));
    }

    final p = _problem;
    if (p == null) {
      return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(),
          body: const Center(child: Text('Problem not found')));
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  _SmallBtn(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    surface: surface2,
                    border: border,
                    color: text2,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p.title,
                      style: AppTextStyles.display18.copyWith(color: text1),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SmallBtn(
                    icon: p.isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    onTap: _toggleBookmark,
                    surface: surface2,
                    border: border,
                    color: p.isBookmarked ? AppColors.accent : text2,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Meta chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  DifficultyChip(difficulty: p.difficulty),
                  _MetaChip(label: p.platform.name, surface: surface3, color: text2),
                  _StatusBadge(status: p.status),
                ],
              ),
              const SizedBox(height: 14),

              // Topic & patterns
              _Card(
                surface: surface2,
                border: border,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOPIC & PATTERNS',
                        style: AppTextStyles.eyebrow.copyWith(color: text3)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.accentLine),
                          ),
                          child: Text(p.topicId,
                              style: AppTextStyles.mono12.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600)),
                        ),
                        ...p.patterns.map((pat) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: surface3,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: border),
                              ),
                              child: Text(pat,
                                  style: AppTextStyles.mono11
                                      .copyWith(color: text2)),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Confidence
              _Card(
                surface: surface2,
                border: border,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CONFIDENCE',
                            style:
                                AppTextStyles.eyebrow.copyWith(color: text3)),
                        Text(
                          ['', 'Shaky', 'Learning', 'Comfortable', 'Confident',
                              'Mastered'][p.confidenceRating.clamp(0, 5)],
                          style: AppTextStyles.mono11.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConfidenceStars(
                            value: p.confidenceRating.clamp(0, 5),
                            size: 26),
                        Text(
                          '${p.confidenceRating}/5',
                          style: AppTextStyles.display16.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Complexity
              if (p.timeComplexity != null || p.spaceComplexity != null) ...[
                Row(
                  children: [
                    if (p.timeComplexity != null)
                      Expanded(
                          child: _ComplexityCard(
                              label: 'Time',
                              value: p.timeComplexity!,
                              surface: surface3,
                              border: border,
                              text3: text3)),
                    if (p.timeComplexity != null && p.spaceComplexity != null)
                      const SizedBox(width: 10),
                    if (p.spaceComplexity != null)
                      Expanded(
                          child: _ComplexityCard(
                              label: 'Space',
                              value: p.spaceComplexity!,
                              surface: surface3,
                              border: border,
                              text3: text3)),
                  ],
                ),
                const SizedBox(height: 14),
              ],

              // Next review
              if (p.nextReviewDate != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.amberSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.24)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_rounded,
                          color: AppColors.amber, size: 18),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Next review',
                              style: AppTextStyles.mono11.copyWith(
                                  color: AppColors.amber,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(p.nextReviewDate!),
                            style: AppTextStyles.display16
                                .copyWith(color: text1, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Notes
              _Card(
                surface: surface2,
                border: border,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MY NOTES',
                            style:
                                AppTextStyles.eyebrow.copyWith(color: text3)),
                        GestureDetector(
                          onTap: _editingNotes ? _saveNotes : () => setState(() => _editingNotes = true),
                          child: Text(
                            _editingNotes ? 'Done' : 'Edit',
                            style: AppTextStyles.mono11.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _editingNotes
                        ? TextField(
                            controller: _notesCtrl,
                            minLines: 4,
                            maxLines: null,
                            style: AppTextStyles.body14.copyWith(color: text1),
                            decoration: InputDecoration(
                              hintText:
                                  'Write your approach, key insight, or gotcha…',
                              hintStyle:
                                  AppTextStyles.body14.copyWith(color: text3),
                              filled: true,
                              fillColor: surface3,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )
                        : Text(
                            p.notes?.isNotEmpty == true
                                ? p.notes!
                                : 'No notes yet — tap Edit to add your approach.',
                            style: AppTextStyles.body14.copyWith(
                              color: p.notes?.isNotEmpty == true
                                  ? text1
                                  : text3,
                              fontStyle: p.notes?.isNotEmpty == true
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Review history
              if (p.reviewHistory.isNotEmpty) ...[
                _Card(
                  surface: surface2,
                  border: border,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REVIEW HISTORY',
                          style: AppTextStyles.eyebrow.copyWith(color: text3)),
                      const SizedBox(height: 16),
                      ...p.reviewHistory.asMap().entries.map((e) {
                        final isLast = e.key == p.reviewHistory.length - 1;
                        final entry = e.value;
                        return _ReviewHistoryRow(
                          entry: entry,
                          isLast: isLast,
                          border: border,
                          text1: text1,
                          text3: text3,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Actions
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _delete,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: surface2,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline_rounded,
                                color: AppColors.red, size: 17),
                            const SizedBox(width: 7),
                            Text('Delete',
                                style: AppTextStyles.display16.copyWith(
                                    color: AppColors.red, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _openReview,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.replay_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('Re-attempt',
                                style: AppTextStyles.display16.copyWith(
                                    color: AppColors.onAccent)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openReview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReviewModal(problem: _problem!),
    ).then((_) => _load());
  }

  Future<void> _toggleBookmark() async {
    final p = _problem;
    if (p == null) return;
    p.isBookmarked = !p.isBookmarked;
    await ProblemRepository(ref.read(isarProvider)).updateProblem(p);
    setState(() {});
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 0) return '${-diff} day${-diff == 1 ? '' : 's'} overdue';
    return 'in $diff day${diff == 1 ? '' : 's'}';
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  final Color surface, border;

  const _Card({required this.child, required this.surface, required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color surface, border, color;

  const _SmallBtn({
    required this.icon,
    required this.onTap,
    required this.surface,
    required this.border,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color surface, color;

  const _MetaChip(
      {required this.label, required this.surface, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: AppTextStyles.mono11
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProblemStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = switch (status) {
      ProblemStatus.solved => ('Solved', AppColors.emerald, AppColors.emeraldSoft),
      ProblemStatus.needsReview => ('Needs Review', AppColors.amber, AppColors.amberSoft),
      ProblemStatus.attempted => ('Attempted', AppColors.darkText3, AppColors.darkSurface3),
      ProblemStatus.unsolved => ('Unsolved', AppColors.darkText3, AppColors.darkSurface3),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label,
          style: AppTextStyles.mono11
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _ComplexityCard extends StatelessWidget {
  final String label, value;
  final Color surface, border, text3;

  const _ComplexityCard({
    required this.label,
    required this.value,
    required this.surface,
    required this.border,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: AppTextStyles.eyebrow.copyWith(color: text3)),
          const SizedBox(height: 5),
          Text(value,
              style: AppTextStyles.mono13Medium
                  .copyWith(color: AppColors.accent, fontSize: 15)),
        ],
      ),
    );
  }
}

class _ReviewHistoryRow extends StatelessWidget {
  final ReviewEntry entry;
  final bool isLast;
  final Color border, text1, text3;

  const _ReviewHistoryRow({
    required this.entry,
    required this.isLast,
    required this.border,
    required this.text1,
    required this.text3,
  });

  Color get _dotColor {
    final c = entry.confidenceRating;
    if (c <= 2) return AppColors.red;
    if (c == 3) return AppColors.amber;
    return AppColors.emerald;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: _dotColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      spreadRadius: 2)
                ],
              ),
            ),
            if (!isLast)
              Container(
                  width: 2,
                  height: 32,
                  margin: const EdgeInsets.only(top: 4),
                  color: border),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ['', 'Shaky', 'Learning', 'Comfortable', 'Confident',
                          'Mastered'][entry.confidenceRating.clamp(0, 5)],
                      style: AppTextStyles.mono12.copyWith(
                          color: _dotColor, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _formatDate(entry.reviewedAt),
                      style: AppTextStyles.mono11.copyWith(color: text3),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (i) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: i < entry.confidenceRating
                            ? _dotColor
                            : AppColors.darkSurface3,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
