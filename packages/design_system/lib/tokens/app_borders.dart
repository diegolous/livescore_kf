import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppBorders {
  // Border widths
  static const double thin = 0.5;
  static const double regular = 1.0;
  static const double timeline = 1.5;
  static const double accent = 3.0;

  static const liveBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.liveBorder, width: regular),
  );

  static const upcomingBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.upcomingBorder, width: regular),
  );

  static const surfaceBorderDark = Border.fromBorderSide(
    BorderSide(color: AppColors.borderDark, width: regular),
  );

  static const surfaceBorderLight = Border.fromBorderSide(
    BorderSide(color: AppColors.borderLight, width: regular),
  );
}
