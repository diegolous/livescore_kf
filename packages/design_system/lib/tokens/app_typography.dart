import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const _fontFamily = 'Inter';

  // Display / Score
  static const scoreLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const scoreMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.2,
  );

  static const scoreSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.2,
  );

  // Headings
  static const headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // Titles
  static const titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static const titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body
  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Labels / Badges
  static const labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.0,
  );

  static const labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.0,
  );

  // Caption
  static const caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Splash
  static const splashTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 40.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const splashSubtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 3.0,
    height: 1.5,
  );
}
