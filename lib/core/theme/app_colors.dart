import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xFF3D5AFE);
  static const Color primary2 = Color(0xFF3D5AFE);

  static const Color primaryDark = Color(0xFF7C93FF);

  static const Color secondary = Color(0xFFEDEFFF);
  static const Color secondaryDark = Color(0xFF2A2E45);

  // Semantic
  static const Color danger = Color(0xFFE5484D);
  static const Color success = Color(0xFF2F9E64);
  static const Color warning = Color(0xFFF2A93B);

  // Neutrals - light mode
  static const Color onSurfaceLight = Color(0xFF1B1B1F);
  static const Color outlineLight = Color(0xFFC7C7CC);
  static const Color disabledSurfaceLight = Color(0xFFE4E4E7);
  static const Color disabledOnSurfaceLight = Color(0xFF9A9AA2);

  // Neutrals - dark mode
  static const Color onSurfaceDark = Color(0xFFF2F2F5);
  static const Color outlineDark = Color(0xFF4A4B52);
  static const Color disabledSurfaceDark = Color(0xFF2C2D33);
  static const Color disabledOnSurfaceDark = Color(0xFF6C6D75);
}
