import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

enum EventType { goal, yellowCard, redCard, substitution, minuteUpdate }

class EventTile extends StatelessWidget {
  final EventType type;
  final String team;
  final String player;
  final int minute;
  final bool isLast;

  const EventTile({
    super.key,
    required this.type,
    required this.team,
    required this.player,
    required this.minute,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (type) {
      EventType.goal => (Icons.sports_soccer, AppColors.goal, 'GOAL'),
      EventType.yellowCard => (Icons.square, AppColors.yellowCard, 'YELLOW CARD'),
      EventType.redCard => (Icons.square, AppColors.redCard, 'RED CARD'),
      EventType.substitution => (Icons.swap_horiz, AppColors.substitution, 'SUB'),
      EventType.minuteUpdate => (Icons.timer, AppColors.minuteUpdate, 'UPDATE'),
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline connector
          SizedBox(
            width: AppSpacing.timelineWidth,
            child: Column(
              children: [
                Container(
                  width: AppSpacing.eventIconSize,
                  height: AppSpacing.eventIconSize,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: AppColors.opacityLight),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: AppSpacing.iconMd),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: AppBorders.timeline,
                      color: color.withValues(alpha: AppColors.opacityMuted),
                    ),
                  ),
              ],
            ),
          ),
          const Gap.sm(),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label - $team',
                    style: AppTypography.titleSmall.copyWith(color: color),
                  ),
                  const Gap.xxs(),
                  Text(
                    player,
                    style: AppTypography.bodySmall.copyWith(
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Minute badge
          PillBadge(
            label: "$minute'",
            foregroundColor: context.textSecondary,
            backgroundColor: context.surface,
          ),
        ],
      ),
    );
  }
}
