import 'package:isar/isar.dart';

part 'topic_model.g.dart';

enum TopicState { locked, unlocked, active, done }

@collection
class TopicModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, unique: true)
  late String topicId;

  late String name;
  late String description;
  late int estimatedProblems;
  late int displayOrder;

  @enumerated
  late TopicState state;

  List<String> prerequisites = [];

  // step: 1 = foundational, 2 = intermediate, 3 = advanced
  late int step;
}
