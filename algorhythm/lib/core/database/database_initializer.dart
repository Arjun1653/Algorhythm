import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../../features/problem_log/data/models/catalog_entry_model.dart';
import '../../features/problem_log/data/models/problem_model.dart';
import '../../features/roadmap/data/models/topic_model.dart';
import '../../features/streak/data/models/streak_model.dart';

class DatabaseInitializer {
  final Isar _isar;

  DatabaseInitializer(this._isar);

  Future<void> initializeIfNeeded({required bool isStriverMode}) async {
    await _ensureStreak();
    await _ensureTopics();
    await _loadCatalog();
    if (isStriverMode) {
      await seedStriverProblems();
    }
  }

  Future<void> _ensureStreak() async {
    final existing = await _isar.streakModels.get(1);
    if (existing == null) {
      await _isar.writeTxn(() async {
        await _isar.streakModels.put(
          StreakModel()
            ..id = 1
            ..currentStreak = 0
            ..longestStreak = 0
            ..totalSolved = 0
            ..lastSolvedDate = DateTime(2000),
        );
      });
    }
  }

  Future<void> _ensureTopics() async {
    final count = await _isar.topicModels.count();
    if (count > 0) return;

    final topics = _defaultTopics();
    await _isar.writeTxn(() async {
      await _isar.topicModels.putAll(topics);
    });
  }

  Future<void> _loadCatalog() async {
    final count = await _isar.catalogEntrys.count();
    if (count > 0) return;

    try {
      final raw = await rootBundle.loadString('assets/data/catalog.json');
      final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
      final entries = json.map((e) => _catalogFromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.catalogEntrys.putAll(entries);
      });
    } catch (e) {
      // Catalog missing or corrupt — manual entry only
    }
  }

  Future<void> seedStriverProblems() async {
    try {
      final raw = await rootBundle.loadString('assets/data/striver_a2z.json');
      final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
      final existing = await _isar.problemModels
          .filter()
          .catalogIdStartsWith('s')
          .findAll();
      final existingIds = existing.map((p) => p.catalogId).toSet();

      final toSeed = <ProblemModel>[];
      for (final item in json) {
        final map = item as Map<String, dynamic>;
        final cid = map['id'] as String;
        if (!existingIds.contains(cid)) {
          toSeed.add(_striverProblemFromJson(map));
        }
      }

      if (toSeed.isEmpty) return;
      await _isar.writeTxn(() async {
        await _isar.problemModels.putAll(toSeed);
      });
    } catch (e) {
      // Striver JSON missing — skip seeding
    }
  }

  CatalogEntry _catalogFromJson(Map<String, dynamic> map) {
    return CatalogEntry()
      ..catalogId = map['id'] as String
      ..name = map['name'] as String
      ..source = map['source'] as String
      ..platform = _parsePlatform(map['platform'] as String)
      ..difficulty = _parseDifficulty(map['difficulty'] as String)
      ..topic = map['topic'] as String
      ..patterns = List<String>.from(map['patterns'] as List)
      ..url = map['url'] as String?;
  }

  ProblemModel _striverProblemFromJson(Map<String, dynamic> map) {
    return ProblemModel()
      ..title = map['name'] as String
      ..platform = _parsePlatform(map['platform'] as String)
      ..difficulty = _parseDifficulty(map['difficulty'] as String)
      ..status = ProblemStatus.unsolved
      ..topicId = 'striver_${map['section']}'
      ..patterns = List<String>.from(map['patterns'] as List)
      ..confidenceRating = 0
      ..url = map['url'] as String?
      ..dateSolved = DateTime(2000)
      ..reviewHistory = []
      ..catalogId = map['id'] as String;
  }

  Platform _parsePlatform(String s) {
    return Platform.values.firstWhere(
      (e) => e.name == s,
      orElse: () => Platform.other,
    );
  }

  Difficulty _parseDifficulty(String s) {
    return Difficulty.values.firstWhere(
      (e) => e.name == s,
      orElse: () => Difficulty.medium,
    );
  }

  List<TopicModel> _defaultTopics() {
    final definitions = [
      // Step 1 — Foundational
      ('arrays_hashing', 'Arrays & Hashing', 'Core array manipulation and hash map techniques', 30, 1, <String>[], 1),
      ('two_pointers', 'Two Pointers', 'Reduce nested loops with converging/diverging pointers', 20, 2, ['arrays_hashing'], 1),
      ('sliding_window', 'Sliding Window', 'Variable/fixed windows over arrays and strings', 20, 3, ['arrays_hashing'], 1),
      ('prefix_sum', 'Prefix Sum', 'Cumulative sums for O(1) range queries', 15, 4, ['arrays_hashing'], 1),
      ('recursion', 'Recursion', 'Base cases, call stacks, and recursive thinking', 20, 5, <String>[], 1),
      ('strings', 'Strings', 'String manipulation, parsing, and encoding tricks', 20, 6, ['arrays_hashing'], 1),
      ('hashing', 'Hashing', 'Hash maps, sets, and collision handling', 15, 7, ['arrays_hashing'], 1),
      // Step 2 — Intermediate
      ('linked_lists', 'Linked Lists', 'Singly/doubly linked lists, fast-slow pointers', 20, 8, ['two_pointers'], 2),
      ('stacks', 'Stacks', 'Monotonic stacks, bracket matching, histogram problems', 20, 9, ['arrays_hashing'], 2),
      ('queues', 'Queues', 'BFS queues, deque, sliding window maximum', 15, 10, ['stacks'], 2),
      ('binary_search', 'Binary Search', 'Search on sorted arrays and on answer space', 20, 11, ['arrays_hashing'], 2),
      ('trees', 'Trees', 'DFS/BFS traversals, height, LCA, path problems', 30, 12, ['recursion', 'queues'], 2),
      ('bsts', 'Binary Search Trees', 'BST properties, insertion, deletion, validation', 20, 13, ['trees', 'binary_search'], 2),
      // Step 3 — Advanced
      ('heaps', 'Heaps', 'Min/max heaps, k-th element, merge k sorted', 20, 14, ['trees'], 3),
      ('graphs', 'Graphs', 'BFS/DFS on general graphs, topological sort, union-find', 35, 15, ['trees', 'queues'], 3),
      ('backtracking', 'Backtracking', 'Subsets, permutations, pruning the search tree', 25, 16, ['recursion'], 3),
      ('dp', 'Dynamic Programming', '1D/2D DP, memoization, tabulation, classic patterns', 40, 17, ['recursion'], 3),
      ('tries', 'Tries', 'Prefix trees, word search, autocomplete', 15, 18, ['hashing', 'trees'], 3),
      ('advanced_graphs', 'Advanced Graphs', "Dijkstra, Bellman-Ford, Floyd-Warshall, Prim's, Kruskal's", 20, 19, ['graphs', 'heaps'], 3),
    ];

    return definitions.map((d) {
      return TopicModel()
        ..topicId = d.$1
        ..name = d.$2
        ..description = d.$3
        ..estimatedProblems = d.$4
        ..displayOrder = d.$5
        ..prerequisites = d.$6
        ..step = d.$7
        ..state = d.$6.isEmpty ? TopicState.unlocked : TopicState.locked;
    }).toList();
  }
}
