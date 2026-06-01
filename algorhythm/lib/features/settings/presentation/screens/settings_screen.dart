import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/database_initializer.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../problem_log/data/models/problem_model.dart';
import '../../../roadmap/data/models/topic_model.dart';
import '../../../streak/data/models/streak_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final darkMode = ref.watch(darkModeProvider);
    final dailyGoal = ref.watch(dailyGoalProvider);
    final appMode = ref.watch(appModeProvider);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.canPop() ? context.pop() : context.go('/'),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: surface2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border),
                      ),
                      child: Icon(Icons.chevron_left_rounded,
                          color: text2, size: 22),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('Settings',
                      style: AppTextStyles.display22.copyWith(color: text1)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Profile card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surface2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.accent,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AlgoRhythm',
                                  style: AppTextStyles.display16
                                      .copyWith(color: text1)),
                              const SizedBox(height: 3),
                              Text(
                                appMode == 'striver'
                                    ? 'Striver Mode · 474 problems'
                                    : 'Custom Mode',
                                style:
                                    AppTextStyles.mono11.copyWith(color: text3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Practice section
                  _SectionLabel(label: 'Practice', text3: text3),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    surface2: surface2,
                    border: border,
                    children: [
                      _SettingRow(
                        icon: Icons.swap_horiz_rounded,
                        label: 'Curriculum mode',
                        sublabel: appMode == 'striver'
                            ? 'Striver A2Z — 474 problems'
                            : 'Custom — log any problem',
                        isDark: isDark,
                        right: _ModeToggle(
                          value: appMode,
                          onChange: (mode) async {
                            ref.read(appModeProvider.notifier).set(mode);
                            if (mode == 'striver') {
                              final isar = ref.read(isarProvider);
                              await DatabaseInitializer(isar)
                                  .seedStriverProblems();
                            }
                          },
                          surface3: surface3,
                          border: border,
                          text3: text3,
                        ),
                      ),
                      Divider(height: 1, color: border, indent: 18, endIndent: 18),
                      _SettingRow(
                        icon: Icons.track_changes_rounded,
                        label: 'Daily goal',
                        sublabel: 'Problems per day',
                        isDark: isDark,
                        right: _GoalPicker(
                          value: dailyGoal,
                          onChange: (v) =>
                              ref.read(dailyGoalProvider.notifier).set(v),
                          surface3: surface3,
                          border: border,
                          text2: text2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Appearance section
                  _SectionLabel(label: 'Appearance', text3: text3),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    surface2: surface2,
                    border: border,
                    children: [
                      _SettingRow(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark mode',
                        sublabel: darkMode ? 'Currently dark' : 'Currently light',
                        isDark: isDark,
                        right: Switch(
                          value: darkMode,
                          onChanged: (v) =>
                              ref.read(darkModeProvider.notifier).set(v),
                          activeThumbColor: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Notifications section
                  _SectionLabel(label: 'Notifications', text3: text3),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    surface2: surface2,
                    border: border,
                    children: [
                      _SettingRow(
                        icon: Icons.notifications_outlined,
                        label: 'Streak reminder',
                        sublabel: 'Daily nudge at 8:00 PM',
                        isDark: isDark,
                        right: _PlaceholderToggle(surface3: surface3, border: border),
                      ),
                      Divider(height: 1, color: border, indent: 18, endIndent: 18),
                      _SettingRow(
                        icon: Icons.repeat_rounded,
                        label: 'Review due alert',
                        sublabel: 'When problems are due for SRS',
                        isDark: isDark,
                        right: _PlaceholderToggle(surface3: surface3, border: border),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Danger zone
                  _SectionLabel(label: 'Danger zone', text3: text3),
                  const SizedBox(height: 8),
                  _SettingsCard(
                    surface2: surface2,
                    border: border,
                    children: [
                      _DangerRow(
                        icon: Icons.delete_outline_rounded,
                        label: 'Reset all data',
                        sublabel: 'Permanently deletes all logged problems',
                        onTap: () => _confirmReset(context, ref),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // About
                  Center(
                    child: Text(
                      'AlgoRhythm v1.0 · Fully offline · Always free\n'
                      'Built with Flutter · No data leaves your device',
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.mono11.copyWith(color: text3, height: 1.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text(
            'This will permanently delete all logged problems, reviews, and streak data. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset',
                  style: TextStyle(color: AppColors.red))),
        ],
      ),
    );
    if (confirmed != true) return;

    final isar = ref.read(isarProvider);
    await isar.writeTxn(() async {
      await isar.problemModels.clear();
      await isar.streakModels.clear();
      await isar.topicModels.clear();
    });

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove('onboarding_complete');

    if (context.mounted) context.go('/onboarding');
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color text3;

  const _SectionLabel({required this.label, required this.text3});

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(),
        style: AppTextStyles.eyebrow.copyWith(color: text3));
  }
}

class _SettingsCard extends StatelessWidget {
  final Color surface2, border;
  final List<Widget> children;

  const _SettingsCard({
    required this.surface2,
    required this.border,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool isDark;
  final Widget right;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.isDark,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final surface3 = isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: surface3,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: text2, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.display16
                        .copyWith(color: text1, fontSize: 14.5)),
                Text(sublabel,
                    style: AppTextStyles.mono11.copyWith(color: text2)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          right,
        ],
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _DangerRow({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.redSoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.red, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.display16
                          .copyWith(color: AppColors.red, fontSize: 14.5)),
                  Text(sublabel,
                      style: AppTextStyles.mono11
                          .copyWith(color: AppColors.red.withValues(alpha: 0.7))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.red, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Mode toggle ────────────────────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChange;
  final Color surface3, border, text3;

  const _ModeToggle({
    required this.value,
    required this.onChange,
    required this.surface3,
    required this.border,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: surface3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final id in ['striver', 'custom'])
            GestureDetector(
              onTap: () => onChange(id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: value == id
                      ? Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkSurface2
                          : AppColors.lightSurface2
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                      color: value == id ? border : Colors.transparent),
                ),
                child: Text(
                  id == 'striver' ? 'Striver' : 'Custom',
                  style: AppTextStyles.display16.copyWith(
                    fontSize: 12,
                    color: value == id ? AppColors.accent : text3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Goal picker ────────────────────────────────────────────────────────────

class _GoalPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;
  final Color surface3, border, text2;

  const _GoalPicker({
    required this.value,
    required this.onChange,
    required this.surface3,
    required this.border,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final n in [1, 2, 3, 5]) ...[
          GestureDetector(
            onTap: () => onChange(n),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 34,
              height: 30,
              decoration: BoxDecoration(
                color: value == n ? AppColors.accent : surface3,
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: value == n ? Colors.transparent : border),
              ),
              child: Center(
                child: Text(
                  '$n',
                  style: AppTextStyles.display16.copyWith(
                    fontSize: 13,
                    color: value == n ? AppColors.onAccent : text2,
                  ),
                ),
              ),
            ),
          ),
          if (n != 5) const SizedBox(width: 5),
        ],
      ],
    );
  }
}

// ── Placeholder toggle (notifications — not yet wired) ─────────────────────

class _PlaceholderToggle extends StatefulWidget {
  final Color surface3, border;

  const _PlaceholderToggle({required this.surface3, required this.border});

  @override
  State<_PlaceholderToggle> createState() => _PlaceholderToggleState();
}

class _PlaceholderToggleState extends State<_PlaceholderToggle> {
  bool _on = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _on,
      onChanged: (v) => setState(() => _on = v),
      activeThumbColor: AppColors.accent,
    );
  }
}
