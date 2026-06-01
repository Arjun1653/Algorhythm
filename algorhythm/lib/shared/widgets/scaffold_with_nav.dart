import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNav({super.key, required this.child});

  static const _tabs = [
    (path: AppRoutes.home, label: 'Home', icon: Icons.home_rounded, activeIcon: Icons.home_rounded),
    (path: AppRoutes.roadmap, label: 'Roadmap', icon: Icons.map_outlined, activeIcon: Icons.map_rounded),
    (path: AppRoutes.log, label: 'Log', icon: Icons.list_alt_outlined, activeIcon: Icons.list_alt_rounded),
    (path: AppRoutes.analytics, label: 'Stats', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return _tabs.indexWhere((t) => t.path == location);
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 32),
        height: 64,
        decoration: BoxDecoration(
          color: navBg.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.13),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final isActive = idx >= 0 && i == idx;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.go(tab.path),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.accentSoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isActive ? tab.activeIcon : tab.icon,
                        size: 20,
                        color: isActive ? AppColors.accent : (isDark ? AppColors.darkText3 : AppColors.lightText3),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tab.label,
                      style: AppTextStyles.eyebrow.copyWith(
                        color: isActive ? AppColors.accent : (isDark ? AppColors.darkText3 : AppColors.lightText3),
                        fontSize: 10.5,
                        letterSpacing: 0.2,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
