import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../presentation/providers/review_provider.dart';
import '../widgets/review_card.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final reviewAsync = ref.watch(dueReviewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Queue', style: AppTextStyles.display18.copyWith(color: text1)),
      ),
      body: reviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (problems) {
          if (problems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 64, color: AppColors.emerald),
                  const SizedBox(height: 16),
                  Text('All caught up!', style: AppTextStyles.display20.copyWith(color: text1)),
                  const SizedBox(height: 8),
                  Text('No reviews due right now.', style: AppTextStyles.body14.copyWith(color: text2)),
                ],
              ),
            );
          }

          final now = DateTime.now();
          final todayStart = DateTime(now.year, now.month, now.day);
          final todayEnd = todayStart.add(const Duration(days: 1));
          final overdue = problems.where((p) =>
              p.nextReviewDate != null && p.nextReviewDate!.isBefore(todayStart)).length;
          final dueToday = problems.where((p) =>
              p.nextReviewDate != null &&
              !p.nextReviewDate!.isBefore(todayStart) &&
              p.nextReviewDate!.isBefore(todayEnd)).length;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface2,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statCell('Overdue', overdue.toString(), AppColors.red, text2),
                    _divider(border),
                    _statCell('Due Today', dueToday.toString(), AppColors.amber, text2),
                    _divider(border),
                    _statCell('Total', problems.length.toString(), text1, text2),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  itemCount: problems.length,
                  itemBuilder: (_, i) => ReviewCard(problem: problems[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statCell(String label, String value, Color valueColor, Color labelColor) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.display22.copyWith(color: valueColor)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.body13.copyWith(color: labelColor)),
      ],
    );
  }

  Widget _divider(Color color) {
    return Container(width: 1, height: 36, color: color);
  }
}
