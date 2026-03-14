import 'package:equatable/equatable.dart';

import '../../domain/entities/match.dart';
import '../../domain/entities/match_event.dart';
import '../../domain/enums/connection_status.dart';

sealed class ScoreboardEvent extends Equatable {
  const ScoreboardEvent();

  @override
  List<Object?> get props => [];
}

final class ScoreboardStarted extends ScoreboardEvent {
  const ScoreboardStarted();
}

final class ScoreboardMatchesUpdated extends ScoreboardEvent {
  final List<Match> matches;

  const ScoreboardMatchesUpdated(this.matches);

  @override
  List<Object?> get props => [matches];
}

final class ScoreboardMatchEventReceived extends ScoreboardEvent {
  final MatchEvent event;

  const ScoreboardMatchEventReceived(this.event);

  @override
  List<Object?> get props => [event];
}

final class ScoreboardConnectionChanged extends ScoreboardEvent {
  final ConnectionStatus status;

  const ScoreboardConnectionChanged(this.status);

  @override
  List<Object?> get props => [status];
}
