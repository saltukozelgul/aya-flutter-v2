// Override the default Material Theme
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppTheme {
  // Create new theme from copy with light theme
  static ThemeData lightTheme = ThemeData.light().copyWith(
    // Set default  font family
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: "Asap",
      ),
    ),

    colorScheme: const ColorScheme.light().copyWith(
      secondary: AppColors.primary,
    ),
    primaryColor: AppColors.primary,

    // ElevatedButton Style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "Asap",
          )),
    ),
  );
}
