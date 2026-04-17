import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const background = Color(0xFFF8F6F0);
  static const surface = Color(0xFFFFFCF6);
  static const surfaceBright = Color(0xFFFFFFFF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF2EEE4);
  static const surfaceContainer = Color(0xFFEAE4D8);
  static const surfaceContainerHigh = Color(0xFFE2DAC9);
  static const surfaceContainerHighest = Color(0xFFD8CFBC);
  static const surfaceVariant = Color(0xFF9A907D);
  static const onSurface = Color(0xFF191714);
  static const onSurfaceVariant = Color(0xFF5F584E);
  static const outline = Color(0xFF7B7366);
  static const outlineVariant = Color(0xFFD4CCBE);
  static const primary = Color(0xFFF3C01A);
  static const primaryContainer = Color(0xFFD69A00);
  static const onPrimary = Color(0xFF2E2200);
  static const secondary = Color(0xFF156BAA);
  static const secondaryContainer = Color(0xFF0C4E7D);
  static const onSecondary = Color(0xFFF7FBFF);
  static const tertiary = Color(0xFFB86B1D);
  static const tertiaryContainer = Color(0xFFF7D4AF);
  static const error = Color(0xFFB42318);
  static const errorContainer = Color(0xFFFDE4E1);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[primary, primaryContainer],
  );
}
