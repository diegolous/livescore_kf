import 'package:equatable/equatable.dart';

import '../../domain/entities/match.dart';
import '../../domain/entities/match_event.dart';
import '../../domain/enums/connection_status.dart';

class ScoreboardState extends Equatable {
  final Map<String, Match> matches;
  final ConnectionStatus connectionStatus;
  final MatchEvent? lastGoalEvent;

  const ScoreboardState({
    this.matches = const {},
    this.connectionStatus = ConnectionStatus.connecting,
    this.lastGoalEvent,
  });

  ScoreboardState copyWith({
    Map<String, Match>? matches,
    ConnectionStatus? connectionStatus,
    MatchEvent? lastGoalEvent,
    bool clearGoalEvent = false,
  }) {
    return ScoreboardState(
      matches: matches ?? this.matches,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      lastGoalEvent:
          clearGoalEvent ? null : (lastGoalEvent ?? this.lastGoalEvent),
    );
  }

  List<Match> get liveMatches =>
      matches.values.where((m) => m.status.name == 'live').toList();

  List<Match> get upcomingMatches =>
      matches.values.where((m) => m.status.name == 'upcoming').toList();

  List<Match> get finishedMatches =>
      matches.values.where((m) => m.status.name == 'finished').toList();

  @override
  List<Object?> get props => [matches, connectionStatus, lastGoalEvent];
}
