import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  static const liveGlow = [
    BoxShadow(
      color: AppColors.liveGlow,
      blurRadius: 8.0,
      spreadRadius: 0.0,
    ),
  ];

  static const cardDark = [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  static const cardLight = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const goalGlow = [
    BoxShadow(
      color: AppColors.goalGlow,
      blurRadius: 12.0,
      spreadRadius: 0.0,
    ),
  ];
}
