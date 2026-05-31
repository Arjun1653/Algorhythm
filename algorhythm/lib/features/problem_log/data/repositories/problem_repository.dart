import 'package:isar/isar.dart';

import '../models/catalog_entry_model.dart';
import '../models/problem_model.dart';

class ProblemRepository {
  final Isar _isar;

  ProblemRepository(this._isar);

  Future<int> addProblem(ProblemModel problem) async {
    return _isar.writeTxn(() => _isar.problemModels.put(problem));
  }

  Future<void> updateProblem(ProblemModel problem) async {
    await _isar.writeTxn(() => _isar.problemModels.put(problem));
  }

  Future<void> deleteProblem(int id) async {
    await _isar.writeTxn(() => _isar.problemModels.delete(id));
  }

  Stream<List<ProblemModel>> watchAll() {
    return _isar.problemModels.watchLazy(fireImmediately: true).asyncMap(
      (_) async {
        final all =
            await _isar.problemModels.filter().idGreaterThan(0).findAll();
        all.sort((a, b) => b.dateSolved.compareTo(a.dateSolved));
        return all;
      },
    );
  }

  Stream<List<ProblemModel>> watchByStatus(ProblemStatus status) {
    return _isar.problemModels.watchLazy(fireImmediately: true).asyncMap(
      (_) => _isar.problemModels.filter().statusEqualTo(status).findAll(),
    );
  }

  Future<List<ProblemModel>> getByTopic(String topicId) {
    return _isar.problemModels.filter().topicIdEqualTo(topicId).findAll();
  }

  Future<List<ProblemModel>> getDueForReview() async {
    final now = DateTime.now();
    final all = await _isar.problemModels
        .filter()
        .nextReviewDateIsNotNull()
        .findAll();
    return all
        .where((p) => p.nextReviewDate!.isBefore(now))
        .toList()
      ..sort((a, b) => a.nextReviewDate!.compareTo(b.nextReviewDate!));
  }

  Stream<List<ProblemModel>> watchDueForReview() {
    return _isar.problemModels.watchLazy(fireImmediately: true).asyncMap(
      (_) => getDueForReview(),
    );
  }

  Future<List<CatalogEntry>> searchCatalog(String query) {
    if (query.trim().isEmpty) return Future.value([]);
    return _isar.catalogEntrys
        .where()
        .nameStartsWith(query.trim())
        .limit(20)
        .findAll();
  }

  Future<ProblemModel?> getById(int id) {
    return _isar.problemModels.get(id);
  }

  Future<Map<DateTime, int>> getHeatmapData() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 365));
    final problems = await _isar.problemModels
        .filter()
        .statusEqualTo(ProblemStatus.solved)
        .and()
        .dateSolvedGreaterThan(cutoff)
        .findAll();

    final result = <DateTime, int>{};
    for (final p in problems) {
      final day =
          DateTime(p.dateSolved.year, p.dateSolved.month, p.dateSolved.day);
      result[day] = (result[day] ?? 0) + 1;
    }
    return result;
  }
}
