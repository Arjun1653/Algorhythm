import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/problem_log/presentation/screens/log_screen.dart';
import '../../features/problem_log/presentation/screens/problem_detail_screen.dart';
import '../../features/roadmap/presentation/screens/roadmap_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/srs/presentation/screens/review_screen.dart';
import '../../features/roadmap/presentation/screens/topic_detail_screen.dart';
import '../../shared/widgets/scaffold_with_nav.dart';
import 'app_routes.dart';

GoRouter buildRouter(SharedPreferences prefs) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final onboardingDone = prefs.getBool('onboarding_complete') ?? false;
      final goingToOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!onboardingDone && !goingToOnboarding) return AppRoutes.onboarding;
      if (onboardingDone && goingToOnboarding) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.review,
        builder: (_, _) => const ReviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.problemDetail,
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProblemDetailScreen(problemId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.topicDetail,
        builder: (_, state) {
          final topicId = state.pathParameters['topicId']!;
          return TopicDetailScreen(topicId: topicId);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
      ShellRoute(
        builder: (_, _, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
          GoRoute(path: AppRoutes.roadmap, builder: (_, _) => const RoadmapScreen()),
          GoRoute(path: AppRoutes.log, builder: (_, _) => const LogScreen()),
          GoRoute(path: AppRoutes.analytics, builder: (_, _) => const AnalyticsScreen()),
        ],
      ),
    ],
  );
}
