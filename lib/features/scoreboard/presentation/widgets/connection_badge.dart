import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/connection_status.dart';
import '../bloc/scoreboard_bloc.dart';
import '../bloc/scoreboard_state.dart';

class AppConnectionBadge extends StatelessWidget {
  const AppConnectionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ScoreboardBloc, ScoreboardState, ConnectionStatus>(
      selector: (state) => state.connectionStatus,
      builder: (context, status) {
        final badgeStatus = switch (status) {
          ConnectionStatus.connected => ConnectionBadgeStatus.connected,
          ConnectionStatus.connecting => ConnectionBadgeStatus.connecting,
          ConnectionStatus.reconnecting => ConnectionBadgeStatus.reconnecting,
          ConnectionStatus.disconnected => ConnectionBadgeStatus.disconnected,
        };
        return ConnectionBadge(status: badgeStatus);
      },
    );
  }
}
