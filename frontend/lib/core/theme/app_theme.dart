import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      surface: Colors.white,
      surfaceContainer: const Color(0xFFF8FAF9),
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),

      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return Colors.grey.shade400;
        },
      ),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.35);
          }

          return Colors.grey.shade300;
        },
      ),
    ),
  );

  // ============================================================
  // DARK THEME
  // ============================================================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      // Main surfaces
      surface: const Color(0xFF1B201F),
      surfaceContainer: const Color(0xFF222827),

      // Text
      onSurface: const Color(0xFFE8EEEC),
      onSurfaceVariant: const Color(0xFFB4BFBB),

      // Borders
      outline: const Color(0xFF394340),
      outlineVariant: const Color(0xFF303936),
    ),

    // Softer dark background.
    // We avoid pure black because it creates too much contrast.
    scaffoldBackgroundColor: const Color(0xFF151A19),

    // ==========================================================
    // APP BAR
    // ==========================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF151A19),
      foregroundColor: Color(0xFFE8EEEC),
      elevation: 0,
      centerTitle: true,
    ),

    // ==========================================================
    // CARDS
    // ==========================================================

    cardTheme: const CardThemeData(
      color: Color(0xFF1B201F),
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    // ==========================================================
    // DIVIDERS
    // ==========================================================

    dividerTheme: const DividerThemeData(
      color: Color(0xFF303936),
      thickness: 1,
    ),

    // ==========================================================
    // INPUT FIELDS
    // ==========================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      // Not black and not white.
      fillColor: const Color(0xFF202624),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF394340),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF394340),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),

      hintStyle: const TextStyle(
        color: Color(0xFF9DA8A4),
      ),

      labelStyle: const TextStyle(
        color: Color(0xFFB4BFBB),
      ),
    ),

    // ==========================================================
    // ELEVATED BUTTON
    // ==========================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ==========================================================
    // TEXT BUTTON
    // ==========================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),

    // ==========================================================
    // SWITCHES
    // ==========================================================

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return const Color(0xFF8C9692);
        },
      ),

      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.35);
          }

          return const Color(0xFF343C39);
        },
      ),

      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return const Color(0xFF4A5551);
        },
      ),
    ),

    // ==========================================================
    // LIST TILES
    // ==========================================================

    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFFE8EEEC),
      iconColor: Color(0xFFB4BFBB),
    ),
  );
}