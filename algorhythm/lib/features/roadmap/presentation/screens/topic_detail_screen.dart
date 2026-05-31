import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TopicDetailScreen extends StatelessWidget {
  final String topicId;

  const TopicDetailScreen({super.key, required this.topicId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;

    return Scaffold(
      appBar: AppBar(title: Text(topicId, style: AppTextStyles.display18.copyWith(color: text1))),
      body: const Center(child: Text('Topic detail — built in Stage 2')),
    );
  }
}
