import '../enums/match_status.dart';

sealed class MatchEvent {
  final String matchId;
  final int minute;
  final String team;
  final String player;
  final DateTime timestamp;
  final MatchStatus status;

  const MatchEvent({
    required this.matchId,
    required this.minute,
    required this.team,
    required this.player,
    required this.timestamp,
    required this.status,
  });
}

final class GoalEvent extends MatchEvent {
  final int homeScore;
  final int awayScore;

  const GoalEvent({
    required super.matchId,
    required super.minute,
    required super.team,
    required super.player,
    required super.timestamp,
    required super.status,
    required this.homeScore,
    required this.awayScore,
  });
}

final class YellowCardEvent extends MatchEvent {
  const YellowCardEvent({
    required super.matchId,
    required super.minute,
    required super.team,
    required super.player,
    required super.timestamp,
    required super.status,
  });
}

final class RedCardEvent extends MatchEvent {
  const RedCardEvent({
    required super.matchId,
    required super.minute,
    required super.team,
    required super.player,
    required super.timestamp,
    required super.status,
  });
}

final class SubstitutionEvent extends MatchEvent {
  const SubstitutionEvent({
    required super.matchId,
    required super.minute,
    required super.team,
    required super.player,
    required super.timestamp,
    required super.status,
  });
}

final class MinuteUpdateEvent extends MatchEvent {
  const MinuteUpdateEvent({
    required super.matchId,
    required super.minute,
    required super.team,
    required super.player,
    required super.timestamp,
    required super.status,
  });
}
