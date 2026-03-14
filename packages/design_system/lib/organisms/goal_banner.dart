import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

class GoalBannerData {
  final String team;
  final String player;
  final int homeScore;
  final int awayScore;

  const GoalBannerData({
    required this.team,
    required this.player,
    required this.homeScore,
    required this.awayScore,
  });
}

class GoalBanner extends StatelessWidget {
  final GoalBannerData data;

  const GoalBanner({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bgColor = context.goalBannerBg;

    return Container(
      margin: AppSpacing.bannerMargin,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadii.lgBorder,
        border: const Border(
          left: BorderSide(color: AppColors.goalGolden, width: AppBorders.accent),
        ),
        boxShadow: AppShadows.goalGlow,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.sports_soccer,
            color: AppColors.goalGolden,
            size: AppSpacing.iconLg,
          ),
          const Gap.md(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GOAL!',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.goalGolden,
                  ),
                ),
                const Gap.xxs(),
                Text(
                  '${data.team} - ${data.player} (${data.homeScore} - ${data.awayScore})',
                  style: AppTypography.bodySmall.copyWith(
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
