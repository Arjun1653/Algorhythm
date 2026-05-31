import 'package:isar/isar.dart';
import 'problem_model.dart';

part 'catalog_entry_model.g.dart';

@collection
class CatalogEntry {
  Id id = Isar.autoIncrement;

  late String catalogId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  late String source;

  @enumerated
  late Platform platform;

  @enumerated
  late Difficulty difficulty;

  @Index(type: IndexType.value)
  late String topic;

  late List<String> patterns;

  String? url;
}
