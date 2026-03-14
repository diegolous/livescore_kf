import 'package:flutter/material.dart';

abstract final class AppSpacing {
  // Base scale (4px grid)
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double xxxxl = 40.0;

  // Component sizes
  static const double iconSm = 12.0;
  static const double iconMd = 14.0;
  static const double iconLg = 22.0;
  static const double dotSm = 6.0;
  static const double dotMd = 8.0;
  static const double eventIconSize = 24.0;
  static const double timelineWidth = 40.0;
  static const double crestDefault = 56.0;
  static const double crestLarge = 64.0;
  static const double crestCard = 44.0;
  static const double progressBarHeight = 2.0;
  static const double splashCornerRadius = 32.0;

  // Semantic aliases
  static const double badgePaddingVLive = 1.0;
  static const double cardPadding = xl;
  static const double cardPaddingVertical = 14.0;
  static const double liveCardPadDelta = 1.0;
  static const double sectionGap = xxxl;
  static const double listItemGap = lg;
  static const double pageHorizontal = lg;
  static const double pagePadding = lg;
  static const double iconGap = xs;
  static const double badgePaddingH = md;
  static const double badgePaddingV = xs;

  // Edge insets helpers
  static const cardInsets = EdgeInsets.symmetric(
    horizontal: cardPadding,
    vertical: cardPaddingVertical,
  );

  static const pageInsets = EdgeInsets.symmetric(horizontal: pageHorizontal);

  static const sectionHeaderInsets = EdgeInsets.fromLTRB(xl, lg, xl, xs);

  static const bannerMargin = EdgeInsets.symmetric(horizontal: lg);
  static const bannerTopPadding = lg;
}
