/// Animation interval and opacity constants used across the design system.
abstract final class AppMotion {
  // Odometer digit transitions
  static const double odometerFadeOutEnd = 0.6;
  static const double odometerFadeInStart = 0.4;

  // Shimmer placeholder
  static const double shimmerOpacityMin = 0.15;
  static const double shimmerOpacityMax = 0.4;

  // Pulsing dot
  static const double pulseOpacityMin = 0.3;

  // Splash animation phases (fraction of total duration)
  static const double splashCornerEnd = 0.4;
  static const double splashSlideStart = 0.55;
}
