import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get darkTheme => _build(Brightness.dark);
  static ThemeData get lightTheme => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface1 = isDark ? AppColors.darkSurface1 : AppColors.lightSurface1;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final text1 = isDark ? AppColors.darkText1 : AppColors.lightText1;
    final text2 = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.accent,
      onPrimary: AppColors.onAccent,
      primaryContainer: AppColors.accentSoft,
      onPrimaryContainer: AppColors.accent,
      secondary: AppColors.emerald,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.emeraldSoft,
      onSecondaryContainer: AppColors.emerald,
      tertiary: AppColors.amber,
      onTertiary: Colors.white,
      error: AppColors.red,
      onError: Colors.white,
      surface: surface2,
      onSurface: text1,
      surfaceContainerHighest: surface1,
      outline: border,
      outlineVariant: border,
      scrim: Colors.black54,
      shadow: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      cardColor: surface2,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
            : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
        titleTextStyle: AppTextStyles.display18.copyWith(color: text1),
        iconTheme: IconThemeData(color: text1),
      ),
      cardTheme: CardThemeData(
        color: surface2,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        selectedColor: AppColors.accentSoft,
        labelStyle: AppTextStyles.chip,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface1,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        hintStyle: AppTextStyles.body15.copyWith(color: text2),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display28.copyWith(color: text1),
        displayMedium: AppTextStyles.display24.copyWith(color: text1),
        displaySmall: AppTextStyles.display22.copyWith(color: text1),
        headlineLarge: AppTextStyles.display20.copyWith(color: text1),
        headlineMedium: AppTextStyles.display18.copyWith(color: text1),
        headlineSmall: AppTextStyles.display16.copyWith(color: text1),
        bodyLarge: AppTextStyles.body15.copyWith(color: text1),
        bodyMedium: AppTextStyles.body14.copyWith(color: text1),
        bodySmall: AppTextStyles.body13.copyWith(color: text2),
        labelLarge: AppTextStyles.body14Medium.copyWith(color: text1),
        labelMedium: AppTextStyles.body13Medium.copyWith(color: text2),
        labelSmall: AppTextStyles.eyebrow,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          textStyle: AppTextStyles.body15SemiBold,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: text2,
      ),
    );
  }
}
