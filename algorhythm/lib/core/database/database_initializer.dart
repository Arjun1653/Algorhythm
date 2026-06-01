import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static const int _schemaVersion = 2;

  Future<void> migrate(SharedPreferences prefs) async {
    final currentVersion = prefs.getInt('db_schema_version') ?? 0;
    if (currentVersion >= _schemaVersion) return;
    if (currentVersion < 2) await _migrateV2EstimatedProblems();
    await prefs.setInt('db_schema_version', _schemaVersion);
  }

  Future<void> _migrateV2EstimatedProblems() async {
    final topics = await _isar.topicModels.filter().idGreaterThan(0).findAll();
    if (topics.isEmpty) return;
    const updates = {
      'arrays_hashing': 90, 'two_pointers': 27, 'sliding_window': 34,
      'prefix_sum': 14, 'recursion': 22, 'strings': 49, 'hashing': 33,
      'linked_lists': 52, 'stacks': 46, 'queues': 8, 'binary_search': 54,
      'trees': 66, 'bsts': 31, 'heaps': 41, 'graphs': 53,
      'backtracking': 33, 'dp': 104, 'tries': 18, 'advanced_graphs': 44,
    };
    final toUpdate = <TopicModel>[];
    for (final topic in topics) {
      final newEstimate = updates[topic.topicId];
      if (newEstimate != null && topic.estimatedProblems != newEstimate) {
        topic.estimatedProblems = newEstimate;
        toUpdate.add(topic);
      }
    }
    if (toUpdate.isEmpty) return;
    await _isar.writeTxn(() async {
      await _isar.topicModels.putAll(toUpdate);
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
      debugPrint('[DatabaseInitializer] Failed to load catalog: $e');
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
      final existingIds = existing.map((p) => p.catalogId).whereType<String>().toSet();

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
      debugPrint('[DatabaseInitializer] Failed to seed Striver problems: $e');
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
      ('arrays_hashing', 'Arrays & Hashing', 'Core array manipulation and hash map techniques', 90, 1, <String>[], 1),
      ('two_pointers', 'Two Pointers', 'Reduce nested loops with converging/diverging pointers', 27, 2, ['arrays_hashing'], 1),
      ('sliding_window', 'Sliding Window', 'Variable/fixed windows over arrays and strings', 34, 3, ['arrays_hashing'], 1),
      ('prefix_sum', 'Prefix Sum', 'Cumulative sums for O(1) range queries', 14, 4, ['arrays_hashing'], 1),
      ('recursion', 'Recursion', 'Base cases, call stacks, and recursive thinking', 22, 5, <String>[], 1),
      ('strings', 'Strings', 'String manipulation, parsing, and encoding tricks', 49, 6, ['arrays_hashing'], 1),
      ('hashing', 'Hashing', 'Hash maps, sets, and collision handling', 33, 7, ['arrays_hashing'], 1),
      // Step 2 — Intermediate
      ('linked_lists', 'Linked Lists', 'Singly/doubly linked lists, fast-slow pointers', 52, 8, ['two_pointers'], 2),
      ('stacks', 'Stacks', 'Monotonic stacks, bracket matching, histogram problems', 46, 9, ['arrays_hashing'], 2),
      ('queues', 'Queues', 'BFS queues, deque, sliding window maximum', 8, 10, ['stacks'], 2),
      ('binary_search', 'Binary Search', 'Search on sorted arrays and on answer space', 54, 11, ['arrays_hashing'], 2),
      ('trees', 'Trees', 'DFS/BFS traversals, height, LCA, path problems', 66, 12, ['recursion', 'queues'], 2),
      ('bsts', 'Binary Search Trees', 'BST properties, insertion, deletion, validation', 31, 13, ['trees', 'binary_search'], 2),
      // Step 3 — Advanced
      ('heaps', 'Heaps', 'Min/max heaps, k-th element, merge k sorted', 41, 14, ['trees'], 3),
      ('graphs', 'Graphs', 'BFS/DFS on general graphs, topological sort, union-find', 53, 15, ['trees', 'queues'], 3),
      ('backtracking', 'Backtracking', 'Subsets, permutations, pruning the search tree', 33, 16, ['recursion'], 3),
      ('dp', 'Dynamic Programming', '1D/2D DP, memoization, tabulation, classic patterns', 104, 17, ['recursion'], 3),
      ('tries', 'Tries', 'Prefix trees, word search, autocomplete', 18, 18, ['hashing', 'trees'], 3),
      ('advanced_graphs', 'Advanced Graphs', "Dijkstra, Bellman-Ford, Floyd-Warshall, Prim's, Kruskal's", 44, 19, ['graphs', 'heaps'], 3),
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
