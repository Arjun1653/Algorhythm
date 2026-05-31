import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/confidence_stars.dart';
import '../../../../shared/widgets/difficulty_chip.dart';
import '../../../streak/domain/usecases/update_streak.dart';
import '../../data/models/catalog_entry_model.dart';
import '../../data/models/problem_model.dart';
import '../../data/repositories/problem_repository.dart';

class AddProblemSheet extends ConsumerStatefulWidget {
  const AddProblemSheet({super.key});

  @override
  ConsumerState<AddProblemSheet> createState() => _AddProblemSheetState();
}

class _AddProblemSheetState extends ConsumerState<AddProblemSheet> {
  bool _isConfirmStep = false;
  bool _fromCatalog = false;
  CatalogEntry? _selectedCatalogEntry;

  // Form fields
  final _nameCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  Platform _platform = Platform.leetcode;
  Difficulty _difficulty = Difficulty.medium;
  String _topicId = 'arrays_hashing';
  final List<String> _patterns = [];
  int _confidence = 3;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _selectCatalogEntry(CatalogEntry entry) {
    setState(() {
      _selectedCatalogEntry = entry;
      _fromCatalog = true;
      _nameCtrl.text = entry.name;
      _platform = entry.platform;
      _difficulty = entry.difficulty;
      _topicId = entry.topic;
      _patterns.clear();
      _patterns.addAll(entry.patterns);
      _urlCtrl.text = entry.url ?? '';
      _isConfirmStep = true;
    });
  }

  void _goManual() {
    setState(() {
      _fromCatalog = false;
      _selectedCatalogEntry = null;
      _isConfirmStep = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface1 : AppColors.lightSurface1;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final borderStrong = isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;

    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: border)),
      ),
      child: Column(
        children: [
          // Handle + header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: borderStrong,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isConfirmStep ? 'NEW ENTRY' : 'SEARCH CATALOG',
                            style: AppTextStyles.eyebrow.copyWith(color: text3),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _isConfirmStep ? 'Log a Problem' : 'Find Problem',
                            style: AppTextStyles.display22.copyWith(color: text1),
                          ),
                        ],
                      ),
                    ),
                    if (_isConfirmStep)
                      _IconBtn(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => setState(() => _isConfirmStep = false),
                        surface: surface3,
                        border: border,
                        color: text2,
                      ),
                    const SizedBox(width: 8),
                    _IconBtn(
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.of(context).pop(),
                      surface: surface3,
                      border: border,
                      color: text2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 40),
              child: _isConfirmStep
                  ? _ConfirmStep(
                      fromCatalog: _fromCatalog,
                      nameCtrl: _nameCtrl,
                      urlCtrl: _urlCtrl,
                      platform: _platform,
                      difficulty: _difficulty,
                      topicId: _topicId,
                      patterns: _patterns,
                      confidence: _confidence,
                      saving: _saving,
                      isDark: isDark,
                      onPlatformChanged: (v) => setState(() => _platform = v),
                      onDifficultyChanged: (v) => setState(() => _difficulty = v),
                      onConfidenceChanged: (v) => setState(() => _confidence = v),
                      onLog: _logProblem,
                    )
                  : _SearchStep(
                      isDark: isDark,
                      onSelect: _selectCatalogEntry,
                      onManual: _goManual,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logProblem() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);

    final isar = ref.read(isarProvider);
    final repo = ProblemRepository(isar);

    final problem = ProblemModel()
      ..title = _nameCtrl.text.trim()
      ..platform = _platform
      ..difficulty = _difficulty
      ..status = ProblemStatus.solved
      ..topicId = _topicId
      ..patterns = List.from(_patterns)
      ..confidenceRating = _confidence
      ..url = _urlCtrl.text.trim().isEmpty ? null : _urlCtrl.text.trim()
      ..dateSolved = DateTime.now()
      ..reviewHistory = []
      ..catalogId = _selectedCatalogEntry?.catalogId;

    // Schedule first review based on confidence
    final reviewDays = [0, 1, 1, 2, 4, 14][_confidence];
    if (reviewDays > 0) {
      problem.nextReviewDate =
          DateTime.now().add(Duration(days: reviewDays));
    }

    try {
      await repo.addProblem(problem);
      await UpdateStreak(isar).call();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${problem.title} logged!'),
            backgroundColor: AppColors.darkSurface3,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ── Search Step ────────────────────────────────────────────────────────────

class _SearchStep extends ConsumerStatefulWidget {
  final bool isDark;
  final ValueChanged<CatalogEntry> onSelect;
  final VoidCallback onManual;

  const _SearchStep({
    required this.isDark,
    required this.onSelect,
    required this.onManual,
  });

  @override
  ConsumerState<_SearchStep> createState() => _SearchStepState();
}

class _SearchStepState extends ConsumerState<_SearchStep> {
  final _ctrl = TextEditingController();
  List<CatalogEntry> _results = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    final repo = ProblemRepository(ref.read(isarProvider));
    final results = await repo.searchCatalog(query);
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final borderStrong = isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: surface3,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentLine, width: 1.5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded, color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  autofocus: true,
                  onChanged: _search,
                  style: AppTextStyles.body15.copyWith(color: text1),
                  decoration: InputDecoration(
                    hintText: 'Search 900+ problems by name or topic…',
                    hintStyle: AppTextStyles.body15.copyWith(color: text3),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
              ),
              if (_ctrl.text.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    _ctrl.clear();
                    setState(() => _results = []);
                  },
                  child: Icon(Icons.close_rounded, color: text3, size: 18),
                ),
                const SizedBox(width: 14),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Results
        if (_results.isNotEmpty)
          ...(_results.map((entry) => GestureDetector(
                onTap: () => widget.onSelect(entry),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: surface2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.name,
                                style: AppTextStyles.display16
                                    .copyWith(color: text1, fontSize: 14.5),
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                DifficultyChip(difficulty: entry.difficulty),
                                const SizedBox(width: 7),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: surface3,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(entry.topic,
                                      style: AppTextStyles.mono11
                                          .copyWith(color: text2)),
                                ),
                                const SizedBox(width: 7),
                                _SourceBadge(source: entry.source),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, color: text3, size: 18),
                    ],
                  ),
                ),
              )))
        else if (_ctrl.text.length < 2) ...[
          Text('SOURCES INCLUDED',
              style: AppTextStyles.eyebrow.copyWith(color: text3)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: const [
              'Striver A2Z', 'NeetCode 150', 'Blind 75', 'Grind 75',
              'LC Top 150', 'AlgoExpert', 'Codeforces', 'GFG Must-Do',
            ].map((s) => _SourceBadge(source: s)).toList(),
          ),
          const SizedBox(height: 14),
          Text(
            'Type at least 2 characters to search.\nAll metadata auto-fills on selection.',
            style: AppTextStyles.mono11
                .copyWith(color: text3, height: 1.6, fontSize: 11.5),
          ),
        ] else ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No match for "${_ctrl.text}". Log it manually below.',
                style: AppTextStyles.mono12.copyWith(color: text3),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],

        const SizedBox(height: 8),
        // Manual entry
        GestureDetector(
          onTap: widget.onManual,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderStrong, style: BorderStyle.solid),
            ),
            child: Row(
              children: [
                Icon(Icons.add_rounded, color: text2, size: 18),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Log manually',
                        style: AppTextStyles.display16
                            .copyWith(color: text2, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Not in catalog — enter details yourself',
                        style: AppTextStyles.mono11.copyWith(color: text3)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Confirm Step ───────────────────────────────────────────────────────────

class _ConfirmStep extends StatelessWidget {
  final bool fromCatalog;
  final TextEditingController nameCtrl;
  final TextEditingController urlCtrl;
  final Platform platform;
  final Difficulty difficulty;
  final String topicId;
  final List<String> patterns;
  final int confidence;
  final bool saving;
  final bool isDark;
  final ValueChanged<Platform> onPlatformChanged;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final ValueChanged<int> onConfidenceChanged;
  final VoidCallback onLog;

  const _ConfirmStep({
    required this.fromCatalog,
    required this.nameCtrl,
    required this.urlCtrl,
    required this.platform,
    required this.difficulty,
    required this.topicId,
    required this.patterns,
    required this.confidence,
    required this.saving,
    required this.isDark,
    required this.onPlatformChanged,
    required this.onDifficultyChanged,
    required this.onConfidenceChanged,
    required this.onLog,
  });

  @override
  Widget build(BuildContext context) {
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fromCatalog) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.emeraldSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.emerald.withValues(alpha: 0.24)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_rounded,
                    color: AppColors.emerald, size: 16),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Auto-filled from catalog. Just rate your confidence and you\'re done.',
                    style: AppTextStyles.mono11
                        .copyWith(color: AppColors.emerald, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        // Name
        _FieldLabel(label: 'PROBLEM NAME', text3: text3),
        const SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: surface3,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: nameCtrl,
            style: AppTextStyles.body15.copyWith(color: text1),
            decoration: InputDecoration(
              hintText: 'e.g. Group Anagrams',
              hintStyle: AppTextStyles.body15.copyWith(color: text3),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.transparent,
              filled: false,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Platform
        _FieldLabel(label: 'PLATFORM', text3: text3),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: Platform.values.map((p) {
              final isOn = platform == p;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onPlatformChanged(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: isOn ? AppColors.accentSoft : surface3,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              isOn ? AppColors.accentLine : border),
                    ),
                    child: Text(
                      p.name,
                      style: AppTextStyles.body14SemiBold.copyWith(
                          color: isOn ? AppColors.accent : text2),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Difficulty
        _FieldLabel(label: 'DIFFICULTY', text3: text3),
        const SizedBox(height: 10),
        Row(
          children: Difficulty.values.map((d) {
            final isOn = difficulty == d;
            final (color, soft) = switch (d) {
              Difficulty.easy => (AppColors.emerald, AppColors.emeraldSoft),
              Difficulty.medium => (AppColors.amber, AppColors.amberSoft),
              Difficulty.hard => (AppColors.red, AppColors.redSoft),
            };
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: d == Difficulty.hard ? 0 : 8),
                child: GestureDetector(
                  onTap: () => onDifficultyChanged(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isOn ? soft : surface3,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isOn
                            ? color.withValues(alpha: 0.35)
                            : border,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        d.name[0].toUpperCase() + d.name.substring(1),
                        style: AppTextStyles.display16.copyWith(
                            color: isOn ? color : text2,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Confidence
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _FieldLabel(label: 'CONFIDENCE', text3: text3),
            Text(
              ['', 'Shaky', 'Learning', 'Comfortable', 'Confident',
                  'Mastered'][confidence],
              style: AppTextStyles.mono11
                  .copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConfidencePicker(
              value: confidence,
              onChanged: onConfidenceChanged,
              size: 30,
            ),
            Text(
              '$confidence/5',
              style: AppTextStyles.display16.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // URL
        _FieldLabel(label: 'LINK', text3: text3),
        const SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: surface3,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(Icons.link_rounded, color: text3, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: urlCtrl,
                  style: AppTextStyles.mono13.copyWith(color: text1),
                  decoration: InputDecoration(
                    hintText: 'leetcode.com/problems/…',
                    hintStyle:
                        AppTextStyles.mono13.copyWith(color: text3),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // CTA
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: saving ? null : onLog,
            child: saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text('Log Problem',
                          style: AppTextStyles.display16
                              .copyWith(color: AppColors.onAccent)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final Color text3;

  const _FieldLabel({required this.label, required this.text3});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTextStyles.eyebrow.copyWith(color: text3));
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color surface, border, color;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    required this.surface,
    required this.border,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  final String source;

  const _SourceBadge({required this.source});

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (source) {
      'Striver A2Z' => (AppColors.accent, AppColors.accentSoft),
      'NeetCode 150' => (AppColors.emerald, AppColors.emeraldSoft),
      'Blind 75' || 'Grind 75' => (AppColors.amber, AppColors.amberSoft),
      _ => (AppColors.darkText2, AppColors.darkSurface3),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
      child: Text(
        source,
        style: AppTextStyles.mono11
            .copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 10),
      ),
    );
  }
}
