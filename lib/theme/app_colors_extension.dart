//this file defines colors for our app-specific concepts
//it is essentially a place to store custom semantic colors
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

  //chart colors for different data on the chart
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  //heatmap colors for levels activity intensity from lowest to highest
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
    required this.heat4,
  });

  @override
  AppColors copyWith({
    Color? brand,
    Color? streak,
    Color? badge,
    Color? success,
    Color? warning,
    Color? danger,
    Color? surfaceSoft,
    Color? surfaceMuted,
    Color? surfaceStrong,
    Color? cardBorder,
    Color? navBorder,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? heat0,
    Color? heat1,
    Color? heat2,
    Color? heat3,
    Color? heat4,
  }) {
    return AppColors(
      brand: brand ?? this.brand,
      streak: streak ?? this.streak,
      badge: badge ?? this.badge,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      cardBorder: cardBorder ?? this.cardBorder,
      navBorder: navBorder ?? this.navBorder,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
      heat0: heat0 ?? this.heat0,
      heat1: heat1 ?? this.heat1,
      heat2: heat2 ?? this.heat2,
      heat3: heat3 ?? this.heat3,
      heat4: heat4 ?? this.heat4,
    );
  }

  //nifty method that allows us to interpolate between two AppColors instances
  //like for switching theme
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppColors(
      brand: lerpColor(brand, other.brand),
      streak: lerpColor(streak, other.streak),
      badge: lerpColor(badge, other.badge),
      success: lerpColor(success, other.success),
      warning: lerpColor(warning, other.warning),
      danger: lerpColor(danger, other.danger),
      surfaceSoft: lerpColor(surfaceSoft, other.surfaceSoft),
      surfaceMuted: lerpColor(surfaceMuted, other.surfaceMuted),
      surfaceStrong: lerpColor(surfaceStrong, other.surfaceStrong),
      cardBorder: lerpColor(cardBorder, other.cardBorder),
      navBorder: lerpColor(navBorder, other.navBorder),
      chart1: lerpColor(chart1, other.chart1),
      chart2: lerpColor(chart2, other.chart2),
      chart3: lerpColor(chart3, other.chart3),
      chart4: lerpColor(chart4, other.chart4),
      chart5: lerpColor(chart5, other.chart5),
      heat0: lerpColor(heat0, other.heat0),
      heat1: lerpColor(heat1, other.heat1),
      heat2: lerpColor(heat2, other.heat2),
      heat3: lerpColor(heat3, other.heat3),
      heat4: lerpColor(heat4, other.heat4),
    );
  }
}
