import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ConfidenceStars extends StatelessWidget {
  final int value; // 1–5
  final double size;

  const ConfidenceStars({super.key, required this.value, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor = isDark ? AppColors.darkText3 : AppColors.lightText3;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < value ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < value ? AppColors.amber : emptyColor,
        );
      }),
    );
  }
}

class ConfidencePicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  const ConfidencePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor = isDark ? AppColors.darkText3 : AppColors.lightText3;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final rating = i + 1;
        return GestureDetector(
          onTap: () => onChanged(rating),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              rating <= value ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: rating <= value ? AppColors.amber : emptyColor,
            ),
          ),
        );
      }),
    );
  }
}
