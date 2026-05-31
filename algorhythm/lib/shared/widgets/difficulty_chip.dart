import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/problem_log/data/models/problem_model.dart';

class DifficultyChip extends StatelessWidget {
  final Difficulty difficulty;

  const DifficultyChip({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = switch (difficulty) {
      Difficulty.easy => ('Easy', AppColors.emerald, AppColors.emeraldSoft),
      Difficulty.medium => ('Medium', AppColors.amber, AppColors.amberSoft),
      Difficulty.hard => ('Hard', AppColors.red, AppColors.redSoft),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.chip.copyWith(color: color),
      ),
    );
  }
}
