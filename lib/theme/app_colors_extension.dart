import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color brand;
  final Color streak;
  final Color badge;
  final Color success;
  final Color warning;
  final Color danger;

  final Color surfaceSoft;
  final Color surfaceMuted;
  final Color surfaceStrong;

  final Color cardBorder;
  final Color navBorder;

  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  final Color heat0;
  final Color heat1;
  final Color heat2;
  final Color heat3;
  final Color heat4;

  const AppColors({
    required this.brand,
    required this.streak,
    required this.badge,
    required this.success,
    required this.warning,
    required this.danger,
    required this.surfaceSoft,
    required this.surfaceMuted,
    required this.surfaceStrong,
    required this.cardBorder,
    required this.navBorder,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.heat0,
    required this.heat1,
    required this.heat2,
    required this.heat3,
    required this.heat4
  });

}