import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  // Display — Space Grotesk
  static const TextStyle display28 = TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 28, height: 1.2);
  static const TextStyle display24 = TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 24, height: 1.25);
  static const TextStyle display22 = TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 22, height: 1.27);
  static const TextStyle display20 = TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 20, height: 1.3);
  static const TextStyle display18 = TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w600, fontSize: 18, height: 1.33);
  static const TextStyle display16 = TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w600, fontSize: 16, height: 1.4);

  // Body — Plus Jakarta Sans
  static const TextStyle body15 = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w400, fontSize: 15, height: 1.5);
  static const TextStyle body15Medium = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w500, fontSize: 15, height: 1.5);
  static const TextStyle body15SemiBold = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w600, fontSize: 15, height: 1.5);
  static const TextStyle body14 = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w400, fontSize: 14, height: 1.5);
  static const TextStyle body14Medium = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w500, fontSize: 14, height: 1.5);
  static const TextStyle body14SemiBold = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w600, fontSize: 14, height: 1.5);
  static const TextStyle body13 = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w400, fontSize: 13, height: 1.5);
  static const TextStyle body13Medium = TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w500, fontSize: 13, height: 1.5);

  // Mono — JetBrains Mono
  static const TextStyle mono13 = TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w400, fontSize: 13, height: 1.6);
  static const TextStyle mono13Medium = TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w500, fontSize: 13, height: 1.6);
  static const TextStyle mono13SemiBold = TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w600, fontSize: 13, height: 1.6);
  static const TextStyle mono12 = TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w400, fontSize: 12, height: 1.6);
  static const TextStyle mono12Medium = TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w500, fontSize: 12, height: 1.6);
  static const TextStyle mono11 = TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w400, fontSize: 11, height: 1.6);

  // Eyebrow — JetBrains Mono 500, 11px, uppercase, 1.6px tracking
  static const TextStyle eyebrow = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    letterSpacing: 1.6,
    height: 1.6,
  );

  // Chip — JetBrains Mono 600, 11px, 0.4px tracking, uppercase
  static const TextStyle chip = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w600,
    fontSize: 11,
    letterSpacing: 0.4,
    height: 1.4,
  );
}
