import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand accent
  static const accent = Color(0xFF7C3AED);
  static const accentPress = Color(0xFF6829D1);
  static const accentSoft = Color(0x297C3AED);
  static const accentLine = Color(0x517C3AED);
  static const onAccent = Colors.white;

  // Semantic — fixed across modes
  static const emerald = Color(0xFF10B981);
  static const emeraldSoft = Color(0x2910B981);
  static const amber = Color(0xFFF59E0B);
  static const amberSoft = Color(0x29F59E0B);
  static const red = Color(0xFFF25555);
  static const redSoft = Color(0x29F25555);

  // Dark surface palette
  static const darkBg = Color(0xFF0D0D0D);
  static const darkSurface1 = Color(0xFF151516);
  static const darkSurface2 = Color(0xFF1A1A1C);
  static const darkSurface3 = Color(0xFF232327);
  static const darkSurfacePress = Color(0xFF2A2A2E);
  static const darkBorder = Color(0x12FFFFFF);
  static const darkBorderStrong = Color(0x21FFFFFF);
  static const darkText1 = Color(0xFFF4F4F3);
  static const darkText2 = Color(0xFF9C9C9A);
  static const darkText3 = Color(0xFF67676A);

  // Dark heat colors
  static const darkHeat0 = Color(0xFF1A1A1C);
  static const darkHeat1 = Color(0xFF3D2A6E);
  static const darkHeat2 = Color(0xFF5E3DB8);
  static const darkHeat3 = accent;

  // Light surface palette
  static const lightBg = Color(0xFFF4F3F0);
  static const lightSurface1 = Color(0xFFFBFBF9);
  static const lightSurface2 = Color(0xFFFFFFFF);
  static const lightSurface3 = Color(0xFFF1F0EC);
  static const lightSurfacePress = Color(0xFFECEBE6);
  static const lightBorder = Color(0x1714120F);
  static const lightBorderStrong = Color(0x2914120F);
  static const lightText1 = Color(0xFF1A1916);
  static const lightText2 = Color(0xFF6C6A64);
  static const lightText3 = Color(0xFF9B988F);

  // Light heat colors
  static const lightHeat0 = Color(0xFFE7E6E1);
  static const lightHeat1 = Color(0xFFBBA7E8);
  static const lightHeat2 = Color(0xFF9474D9);
  static const lightHeat3 = accent;
}
