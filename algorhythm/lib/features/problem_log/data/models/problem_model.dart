import 'package:isar/isar.dart';
import 'review_entry_model.dart';

part 'problem_model.g.dart';

enum Platform { leetcode, codeforces, gfg, neetcode, algoexpert, hackerrank, other }

enum Difficulty { easy, medium, hard }

enum ProblemStatus { unsolved, attempted, solved, needsReview }

@collection
class ProblemModel {
  Id id = Isar.autoIncrement;

  late String title;

  @enumerated
  late Platform platform;

  @enumerated
  late Difficulty difficulty;

  @Index(type: IndexType.value)
  @enumerated
  late ProblemStatus status;

  @Index(type: IndexType.value)
  late String topicId;

  late List<String> patterns;

  late int confidenceRating;

  String? notes;
  String? url;
  String? timeComplexity;
  String? spaceComplexity;

  @Index(type: IndexType.value)
  late DateTime dateSolved;

  @Index(type: IndexType.value)
  DateTime? nextReviewDate;

  late List<ReviewEntry> reviewHistory;

  String? catalogId;

  bool isBookmarked = false;
}
