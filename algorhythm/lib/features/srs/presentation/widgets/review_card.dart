import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/difficulty_chip.dart';
import '../../../problem_log/data/models/problem_model.dart';
import 'review_modal.dart';

class ReviewCard extends ConsumerWidget {
  final ProblemModel problem;

  const ReviewCard({super.key, required this.problem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final isOverdue = problem.nextReviewDate != null &&
        problem.nextReviewDate!.isBefore(DateTime.now());

    return GestureDetector(
      onTap: () => _openReviewModal(context, ref),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isOverdue) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.redSoft,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'OVERDUE',
                            style: AppTextStyles.chip.copyWith(color: AppColors.red),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      DifficultyChip(difficulty: problem.difficulty),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(problem.title,
                      style: AppTextStyles.display16.copyWith(color: text1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(problem.topicId,
                      style: AppTextStyles.body13.copyWith(color: text2)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.chevron_right_rounded, color: text2),
          ],
        ),
      ),
    );
  }

  void _openReviewModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReviewModal(problem: problem),
    );
  }
}
