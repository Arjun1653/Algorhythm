import 'dart:math';

class ReviewResult {
  final DateTime nextReviewDate;
  final double newEaseFactor;
  final int intervalDays;

  const ReviewResult({
    required this.nextReviewDate,
    required this.newEaseFactor,
    required this.intervalDays,
  });
}

class ScheduleReview {
  static const _initialIntervals = [0, 1, 1, 2, 4, 14];

  ReviewResult call({
    required int confidenceRating, // 1–5
    required double currentEaseFactor,
    required int reviewCount,
    required int previousIntervalDays,
  }) {
    assert(confidenceRating >= 1 && confidenceRating <= 5);

    final newEaseFactor = max(
      1.3,
      currentEaseFactor +
          0.1 -
          (5 - confidenceRating) * (0.08 + (5 - confidenceRating) * 0.02),
    );

    final int intervalDays;
    if (reviewCount == 0) {
      intervalDays = _initialIntervals[confidenceRating];
    } else {
      intervalDays = max(1, (previousIntervalDays * newEaseFactor).round());
    }

    final nextReviewDate = DateTime.now().add(Duration(days: intervalDays));

    return ReviewResult(
      nextReviewDate: nextReviewDate,
      newEaseFactor: newEaseFactor,
      intervalDays: intervalDays,
    );
  }
}
