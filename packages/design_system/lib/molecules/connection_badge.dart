import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

enum ConnectionBadgeStatus { connecting, connected, reconnecting, disconnected }

class ConnectionBadge extends StatelessWidget {
  final ConnectionBadgeStatus status;

  const ConnectionBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = switch (status) {
      ConnectionBadgeStatus.connected => (
        AppColors.connected,
        'CONNECTED',
        Icons.wifi,
      ),
      ConnectionBadgeStatus.connecting => (
        AppColors.yellowCard,
        'CONNECTING',
        Icons.wifi_find,
      ),
      ConnectionBadgeStatus.reconnecting => (
        AppColors.reconnecting,
        'RECONNECTING',
        Icons.wifi_off,
      ),
      ConnectionBadgeStatus.disconnected => (
        AppColors.disconnected,
        'DISCONNECTED',
        Icons.wifi_off,
      ),
    };

    return PillBadge(
      label: label,
      foregroundColor: color,
      backgroundColor: color.withValues(alpha: AppColors.opacitySubtle),
      borderColor: color.withValues(alpha: AppColors.opacityMedium),
      leading: Icon(icon, size: AppSpacing.iconSm, color: color),
    );
  }
}
