//this file defines methods for shortcutting access to the chart and heatmap colors
import 'package:flutter/material.dart';
import 'app_colors_extension.dart';

class ChartPalette {
  static List<Color> chartColors(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return [
      appColors.chart1,
      appColors.chart2,
      appColors.chart3,
      appColors.chart4,
      appColors.chart5,
    ];
  }

  static List<Color> heatmapColors(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return [
      appColors.heat0,
      appColors.heat1,
      appColors.heat2,
      appColors.heat3,
      appColors.heat4,
    ];
  }
}