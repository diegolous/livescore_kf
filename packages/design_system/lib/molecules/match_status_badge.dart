import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

enum MatchBadgeVariant { live, upcoming, finished }

class MatchStatusBadge extends StatelessWidget {
  final MatchBadgeVariant variant;
  final String label;

  const MatchStatusBadge({
    super.key,
    required this.variant,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      MatchBadgeVariant.live => PillBadge(
        label: label,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.live,
        leading: const PulsingDot(
          color: AppColors.white,
          size: AppSpacing.dotSm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.badgePaddingVLive,
        ),
      ),
      MatchBadgeVariant.upcoming => PillBadge(
        label: label,
        foregroundColor: AppColors.upcoming,
        backgroundColor: AppColors.upcomingSubtle,
        borderColor: AppColors.upcomingBorder,
      ),
      MatchBadgeVariant.finished => PillBadge(
        label: label,
        foregroundColor: context.finishedForeground,
        backgroundColor: context.finishedBadgeBg,
      ),
    };
  }
}
