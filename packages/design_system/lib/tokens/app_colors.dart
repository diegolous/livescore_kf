import 'package:flutter/material.dart';

extension AppColorsContext on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get textPrimary => _isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get textSecondary => _isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get textTertiary => _isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
  Color get surface => _isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get background => _isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get border => _isDark ? AppColors.borderDark : AppColors.borderLight;
  Color get progressTrackColor => _isDark ? AppColors.progressTrack : AppColors.progressTrackLight;
  Color get goalBannerBg => _isDark ? AppColors.goalBannerDark : AppColors.goalBannerLight;
  Color get finishedForeground => _isDark ? AppColors.finishedForegroundDark : AppColors.finishedForegroundLight;
  Color get finishedBadgeBg => _isDark ? AppColors.finishedSubtle : AppColors.finishedSubtleLight;
  Color get cardShadowColor => _isDark ? AppColors.shadowDark : AppColors.shadowLight;
}

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF00E676);
  static const primaryLight = Color(0xFF66FFA6);

  // Backgrounds - Dark
  static const backgroundDark = Color(0xFF0D1117);
  static const surfaceDark = Color(0xFF161B22);
  static const borderDark = Color(0xFF30363D);

  // Backgrounds - Light
  static const backgroundLight = Color(0xFFF8F6F6);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const borderLight = Color(0xFFE2E8F0);

  // Text - Dark
  static const textPrimaryDark = Color(0xFFFFFFFF);
  static const textSecondaryDark = Color(0xFF8B949E);
  static const textTertiaryDark = Color(0xFF6E7681);

  // Text - Light
  static const textPrimaryLight = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF64748B);
  static const textTertiaryLight = Color(0xFF94A3B8);

  // Status
  static const live = Color(0xFFEF4444);
  static const liveGlow = Color(0x33EF4444);
  static const liveBorder = Color(0x80EF4444);
  static const upcoming = Color(0xFF3B82F6);
  static const upcomingSubtle = Color(0x1A3B82F6);
  static const upcomingBorder = Color(0x333B82F6);
  static const finished = Color(0xFF6B7280);
  static const finishedSubtle = Color(0xFF1F2937);
  static const finishedSubtleLight = Color(0xFFF1F5F9);
  static const finishedForegroundDark = Color(0xFFFFFFFF);
  static const finishedForegroundLight = Color(0xFF6B7280);

  // Events
  static const goal = Color(0xFF22C55E);
  static const goalGolden = Color(0xFFFFD700);
  static const yellowCard = Color(0xFFF59E0B);
  static const redCard = Color(0xFFEF4444);
  static const substitution = Color(0xFF3B82F6);
  static const minuteUpdate = Color(0xFF6B7280);

  // Connection
  static const connected = Color(0xFF22C55E);
  static const connectedSubtle = Color(0x1A22C55E);
  static const connectedBorder = Color(0x4D22C55E);
  static const reconnecting = Color(0xFFEF4444);
  static const disconnected = Color(0xFF6B7280);

  // Goal banner
  static const goalBannerDark = Color(0xFF1C2B1A);
  static const goalBannerLight = Color(0xFFF0F9F0);
  static const goalGlow = Color(0x33FFD700);

  // Shadows
  static const shadowDark = Color(0x1A000000);
  static const shadowLight = Color(0x0D000000);

  // Misc
  static const progressTrack = Color(0xFF1F2937);
  static const progressTrackLight = Color(0xFFE2E8F0);
  static const white = Color(0xFFFFFFFF);
  static const overlay = Color(0x26FFFFFF);

  // Opacity values for programmatic use
  static const double opacitySubtle = 0.12;
  static const double opacityLight = 0.15;
  static const double opacityMuted = 0.2;
  static const double opacityMedium = 0.3;

  // Match constants
  @Deprecated('Use AppConstants.matchDurationMinutes instead')
  static const int matchDurationMinutes = 90;
}
