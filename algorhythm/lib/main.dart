import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/database/database_initializer.dart';
import 'core/database/database_provider.dart';
import 'core/providers/app_settings_provider.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final isar = await openIsar();
  final prefs = await SharedPreferences.getInstance();

  await DatabaseInitializer(isar).migrate(prefs);

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AlgoRhythmApp(),
    ),
  );
}

class AlgoRhythmApp extends ConsumerStatefulWidget {
  const AlgoRhythmApp({super.key});

  @override
  ConsumerState<AlgoRhythmApp> createState() => _AlgoRhythmAppState();
}

class _AlgoRhythmAppState extends ConsumerState<AlgoRhythmApp> {
  late final router = buildRouter(ref.read(sharedPreferencesProvider));

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkModeProvider);
    return MaterialApp.router(
      title: 'AlgoRhythm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
