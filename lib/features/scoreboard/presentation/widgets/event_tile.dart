import 'package:design_system/design_system.dart' as ds;
import 'package:flutter/material.dart';

import '../../domain/entities/match_event.dart';

class AppEventTile extends StatelessWidget {
  final MatchEvent event;
  final bool isLast;

  const AppEventTile({super.key, required this.event, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final type = switch (event) {
      GoalEvent() => ds.EventType.goal,
      YellowCardEvent() => ds.EventType.yellowCard,
      RedCardEvent() => ds.EventType.redCard,
      SubstitutionEvent() => ds.EventType.substitution,
      MinuteUpdateEvent() => ds.EventType.minuteUpdate,
    };

    return ds.EventTile(
      type: type,
      team: event.team,
      player: event.player,
      minute: event.minute,
      isLast: isLast,
    );
  }
}
