import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ConfidenceStars extends StatelessWidget {
  final int value; // 1–5
  final double size;

  const ConfidenceStars({super.key, required this.value, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < value ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < value ? AppColors.amber : AppColors.darkText3,
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
              color: rating <= value ? AppColors.amber : AppColors.darkText3,
            ),
          ),
        );
      }),
    );
  }
}
