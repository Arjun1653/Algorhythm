import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/problem_log/data/models/catalog_entry_model.dart';
import '../../features/problem_log/data/models/problem_model.dart';
import '../../features/roadmap/data/models/topic_model.dart';
import '../../features/streak/data/models/streak_model.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar must be initialized before use');
});

Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      ProblemModelSchema,
      CatalogEntrySchema,
      StreakModelSchema,
      TopicModelSchema,
    ],
    directory: dir.path,
  );
}
