import 'package:flutter/material.dart';

/// BuddyBoss-inspired color system and surfaces
class DesignTheme {
  // Brand colors
  static const Color primary = Color(0xFF5A3FFF); // Purple
  static const Color accent = Color(0xFFFF6B00); // Orange
  static const Color background = Color(0xFFF7F8FA);
  static const Color textDark = Color(0xFF222222);
  static const Color textLight = Color(0xFF666666);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData toThemeData(ThemeData base) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: base.brightness,
    );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: scheme.copyWith(primary: primary, secondary: accent),
      textTheme: base.textTheme.apply(
        displayColor: textDark,
        bodyColor: textDark,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: const Color(0x0F000000),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x10000000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x10000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
