import 'package:isar/isar.dart';

part 'review_entry_model.g.dart';

@embedded
class ReviewEntry {
  late DateTime reviewedAt;
  late int confidenceRating;
  late double easeFactor;
  late int intervalDays;
}
