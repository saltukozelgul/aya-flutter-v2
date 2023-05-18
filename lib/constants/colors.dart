// Make colors class to use colors in the app without initializing them every time.

import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF9E8FB2);
  static const Color primaryVariant = Color(0xFF0D47A1);
  static const Color secondary = Color.fromARGB(255, 88, 28, 200);
  static const Color secondaryVariant = Color(0xFF0D47A1);
  static const Color white = Color(0xFFE6E6E6);
  static const Color disable = Color.fromARGB(173, 51, 51, 51);
}
