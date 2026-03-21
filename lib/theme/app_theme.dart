//this file actually sets the colors for the app
//and assigns those colors to actual UI components
import 'package:flutter/material.dart';
import 'package:chartify/chartify.dart';
import 'app_colors_extension.dart';
import 'app_corners.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const appColors = AppColors(
      brand: Color(0xFF2563EB),
      streak: Color(0xFF7C3AED),
      badge: Color(0xFFF59E0B),
      success: Color(0xFF10B981),
      warning: Color(0xFFF97316),
      danger: Color(0xFFEF4444),

      surfaceSoft: Color(0xFFF8FAFC),
      surfaceMuted: Color(0xFFF1F5F9),
      surfaceStrong: Color(0xFFE2E8F0),

      cardBorder: Color(0xFFE2E8F0),
      navBorder: Color(0xFFE2E8F0),

      chart1: Color(0xFF2563EB),
      chart2: Color(0xFF7C3AED),
      chart3: Color(0xFF10B981),
      chart4: Color(0xFFF59E0B),
      chart5: Color(0xFFEC4899),

      heat0: Color(0xFFE5E7EB),
      heat1: Color(0xFFBFDBFE),
      heat2: Color(0xFF93C5FD),
      heat3: Color(0xFF60A5FA),
      heat4: Color(0xFF2563EB),
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: appColors.brand,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: appColors.surfaceSoft,
      extensions: <ThemeExtension<dynamic>>[
        appColors,
        ChartThemeData.fromSeed(appColors.brand, brightness: Brightness.light),
      ],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppCorners.lg),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppCorners.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppCorners.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppCorners.md),
          borderSide: BorderSide(color: appColors.brand, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: appColors.surfaceMuted,
        selectedColor: appColors.brand,
        disabledColor: appColors.surfaceStrong,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppCorners.pill),
        ),
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColors.brand,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppCorners.xl),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: appColors.brand,
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        showUnselectedLabels: true,
        elevation: 0,
      ),
      dividerColor: appColors.cardBorder,
    );
  } //end lightTheme

  static ThemeData get darkTheme {
    const appColors = AppColors(
      brand: Color(0xFF60A5FA),
      streak: Color(0xFFA78BFA),
      badge: Color(0xFFFBBF24),
      success: Color(0xFF34D399),
      warning: Color(0xFFFB923C),
      danger: Color(0xFFF87171),

      surfaceSoft: Color(0xFF020617),
      surfaceMuted: Color(0xFF0F172A),
      surfaceStrong: Color(0xFF1E293B),

      cardBorder: Color(0xFF1E293B),
      navBorder: Color(0xFF1E293B),

      chart1: Color(0xFF60A5FA),
      chart2: Color(0xFFA78BFA),
      chart3: Color(0xFF34D399),
      chart4: Color(0xFFFBBF24),
      chart5: Color(0xFFF472B6),

      heat0: Color(0xFF1F2937),
      heat1: Color(0xFF1D4ED8),
      heat2: Color(0xFF2563EB),
      heat3: Color(0xFF3B82F6),
      heat4: Color(0xFF60A5FA),
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: appColors.brand,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: appColors.surfaceSoft,
      extensions: <ThemeExtension<dynamic>>[
        appColors,
        ChartThemeData.fromSeed(appColors.brand, brightness: Brightness.dark),
      ],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: appColors.surfaceMuted,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppCorners.lg),
          side: const BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppCorners.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppCorners.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppCorners.md),
          borderSide: BorderSide(color: appColors.brand, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: appColors.surfaceStrong,
        selectedColor: appColors.brand,
        disabledColor: appColors.surfaceStrong,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppCorners.pill),
        ),
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColors.brand,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppCorners.xl),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0F172A),
        selectedItemColor: Color(0xFF60A5FA),
        unselectedItemColor: Color(0xFF94A3B8),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        showUnselectedLabels: true,
        elevation: 0,
      ),
      dividerColor: appColors.cardBorder,
    );
  } //end darkTheme
}
