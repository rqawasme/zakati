import 'package:flutter/material.dart';

/// Zakati brand colour palette
abstract final class AppColors {
  // Primary — Sage Green
  static const Color primary = Color(0xFF4A7C59);
  static const Color primaryDark = Color(0xFF355C42);
  static const Color primaryLight = Color(0xFFEBF2ED);

  // Accent — Warm Gold
  static const Color accent = Color(0xFFB5862A);
  static const Color accentLight = Color(0xFFFBF3E2);

  // Backgrounds
  static const Color background = Color(0xFFF9F7F2);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1C1F1C);
  static const Color textSecondary = Color(0xFF5A6B5D);

  // Divider
  static const Color divider = Color(0xFFDDE5DF);

  // Status
  static const Color error = Color(0xFFC0392B);
  static const Color success = Color(0xFF355C42);

  // AppBar
  static const Color appBarBackground = primary;
  static const Color appBarForeground = Colors.white;
}
