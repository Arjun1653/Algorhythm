import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/database/database_provider.dart';
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

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: AlgoRhythmApp(prefs: prefs),
    ),
  );
}

class AlgoRhythmApp extends ConsumerStatefulWidget {
  final SharedPreferences prefs;

  const AlgoRhythmApp({super.key, required this.prefs});

  @override
  ConsumerState<AlgoRhythmApp> createState() => _AlgoRhythmAppState();
}

class _AlgoRhythmAppState extends ConsumerState<AlgoRhythmApp> {
  late final router = buildRouter(widget.prefs);
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _isDark = widget.prefs.getBool('dark_mode') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AlgoRhythm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
