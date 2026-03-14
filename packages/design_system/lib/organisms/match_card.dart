import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../molecules/molecules.dart';
import '../tokens/tokens.dart';

enum MatchCardVariant { live, upcoming, finished }

class MatchCardData {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final int minute;
  final MatchCardVariant variant;
  final String? homeBadgeUrl;
  final String? awayBadgeUrl;

  const MatchCardData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.minute,
    required this.variant,
    this.homeBadgeUrl,
    this.awayBadgeUrl,
  });
}

class MatchCard extends StatelessWidget {
  final MatchCardData data;
  final VoidCallback? onTap;
  final bool showLiveGlow;

  const MatchCard({
    super.key,
    required this.data,
    this.onTap,
    this.showLiveGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = data.variant == MatchCardVariant.live;
    final isUpcoming = data.variant == MatchCardVariant.upcoming;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: AppRadii.lgBorder,
          border: isLive
              ? (showLiveGlow ? AppBorders.liveBorder : Border.all(color: context.border, width: AppBorders.regular))
              : Border.all(color: context.border, width: AppBorders.thin),
          boxShadow: isLive && showLiveGlow ? AppShadows.liveGlow : null,
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: isLive ? AppSpacing.cardPaddingVertical - AppSpacing.liveCardPadDelta : AppSpacing.cardPaddingVertical,
              ),
              child: ClipRect(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _TeamColumn(
                          name: data.homeTeam,
                          badgeUrl: data.homeBadgeUrl,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          children: [
                            if (isUpcoming)
                              Text(
                                'vs',
                                style: AppTypography.scoreSmall.copyWith(
                                  color: context.textTertiary,
                                ),
                              )
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ScoreDisplay(
                                    score: data.homeScore,
                                    style: AppTypography.scoreMedium.copyWith(
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                    ),
                                    child: Text(
                                      '-',
                                      style: AppTypography.scoreMedium.copyWith(
                                        color: context.textTertiary,
                                      ),
                                    ),
                                  ),
                                  ScoreDisplay(
                                    score: data.awayScore,
                                    style: AppTypography.scoreMedium.copyWith(
                                      color: context.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            if (isLive) const Gap.xs() else const Gap.sm(),
                            _buildBadge(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _TeamColumn(
                          name: data.awayTeam,
                          badgeUrl: data.awayBadgeUrl,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),
            if (isLive)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: showLiveGlow ? 1.0 : 0.0,
                  child: AppProgressBar(
                    value: data.minute / AppConstants.matchDurationMinutes,
                    activeColor: AppColors.live,
                    trackColor: context.progressTrackColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return switch (data.variant) {
      MatchCardVariant.live => MatchStatusBadge(
        variant: MatchBadgeVariant.live,
        label: "LIVE ${data.minute}'",
      ),
      MatchCardVariant.upcoming => const MatchStatusBadge(
        variant: MatchBadgeVariant.upcoming,
        label: 'UPCOMING',
      ),
      MatchCardVariant.finished => const MatchStatusBadge(
        variant: MatchBadgeVariant.finished,
        label: 'FT',
      ),
    };
  }
}

class _TeamColumn extends StatelessWidget {
  final String name;
  final String? badgeUrl;

  const _TeamColumn({
    required this.name,
    this.badgeUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TeamCrest(teamName: name, badgeUrl: badgeUrl, size: AppSpacing.crestCard),
        Text(
          name,
          style: AppTypography.titleSmall.copyWith(
            color: context.textPrimary,
            fontSize: AppTypography.bodySmall.fontSize,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
