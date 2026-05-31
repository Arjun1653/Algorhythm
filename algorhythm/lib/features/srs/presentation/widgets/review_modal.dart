import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/confidence_stars.dart';
import '../../../../shared/widgets/difficulty_chip.dart';
import '../../../problem_log/data/models/problem_model.dart';
import '../../../problem_log/data/models/review_entry_model.dart';
import '../../../problem_log/data/repositories/problem_repository.dart';
import '../../../../core/database/database_provider.dart';
import '../../../streak/domain/usecases/update_streak.dart';
import '../../domain/usecases/schedule_review.dart';

class ReviewModal extends ConsumerStatefulWidget {
  final ProblemModel problem;

  const ReviewModal({super.key, required this.problem});

  @override
  ConsumerState<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends ConsumerState<ReviewModal> {
  int _confidence = 3;
  bool _keepRetrying = true;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: border)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Row(
            children: [
              DifficultyChip(difficulty: widget.problem.difficulty),
              const Spacer(),
              if (widget.problem.url != null)
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  onPressed: () => _openUrl(widget.problem.url!),
                  color: text2,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.problem.title,
              style: AppTextStyles.display20.copyWith(color: text1)),
          const SizedBox(height: 4),
          Text(widget.problem.topicId,
              style: AppTextStyles.body14.copyWith(color: text2)),
          const SizedBox(height: 24),
          // Confidence
          Text('Confidence', style: AppTextStyles.eyebrow.copyWith(color: text2)),
          const SizedBox(height: 12),
          Center(
            child: ConfidencePicker(
              value: _confidence,
              onChanged: (v) => setState(() => _confidence = v),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          // Keep retrying toggle
          Row(
            children: [
              Expanded(
                child: Text('Keep re-attempting until confident',
                    style: AppTextStyles.body14Medium.copyWith(color: text1)),
              ),
              Switch(
                value: _keepRetrying,
                onChanged: (v) => setState(() => _keepRetrying = v),
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _logReview,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Log Review'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logReview() async {
    setState(() => _saving = true);
    final isar = ref.read(isarProvider);
    final repo = ProblemRepository(isar);
    final problem = widget.problem;

    final prevInterval = problem.reviewHistory.isNotEmpty
        ? problem.reviewHistory.last.intervalDays
        : 1;
    final prevEase = problem.reviewHistory.isNotEmpty
        ? problem.reviewHistory.last.easeFactor
        : 2.5;

    final result = ScheduleReview()(
      confidenceRating: _confidence,
      currentEaseFactor: prevEase,
      reviewCount: problem.reviewHistory.length,
      previousIntervalDays: prevInterval,
    );

    problem.reviewHistory.add(
      ReviewEntry()
        ..reviewedAt = DateTime.now()
        ..confidenceRating = _confidence
        ..easeFactor = result.newEaseFactor
        ..intervalDays = result.intervalDays,
    );

    problem.confidenceRating = _confidence;
    problem.status = ProblemStatus.solved;
    problem.nextReviewDate = _keepRetrying ? result.nextReviewDate : null;

    await repo.updateProblem(problem);
    await UpdateStreak(isar).call();

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _keepRetrying
                ? 'Review logged · next in ${result.intervalDays}d'
                : 'Review logged · removed from queue',
          ),
          backgroundColor: AppColors.darkSurface3,
        ),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
