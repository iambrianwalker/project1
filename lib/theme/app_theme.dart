//this file actually sets the colors for the app
//and assigns those colors to actual UI components
import 'package:flutter/material.dart';
import 'package:chartify/chartify.dart';
import 'app_colors_extension.dart';
import 'app_corners.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const appColors = AppColors(
      //##TODO choose colors
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: appColors.brand,
      brightness: Brightness.light,
    );

    return ThemeData(
      //##TODO assign colors to theme properties
    );
  }//end lightTheme

    static ThemeData get darkTheme {
      const appColors = AppColors(
        //##TODO choose colors
      );

      final scheme = ColorScheme.fromSeed(
        seedColor: appColors.brand,
        brightness: Brightness.dark,
      );

      return ThemeData(
        //##TODO assign colors to theme properties
      );
  }//end darkTheme
}