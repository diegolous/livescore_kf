import '../../domain/entities/match_event.dart';
import '../../domain/enums/match_status.dart';

class MatchEventDto {
  final String type;
  final String matchId;
  final int minute;
  final String team;
  final String player;
  final int homeScore;
  final int awayScore;
  final String status;
  final DateTime timestamp;

  const MatchEventDto({
    required this.type,
    required this.matchId,
    required this.minute,
    required this.team,
    required this.player,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.timestamp,
  });

  factory MatchEventDto.fromJson(Map<String, dynamic> json) {
    return MatchEventDto(
      type: json['type'] as String,
      matchId: json['matchId'] as String,
      minute: json['minute'] as int,
      team: json['team'] as String,
      player: json['player'] as String,
      homeScore: json['homeScore'] as int,
      awayScore: json['awayScore'] as int,
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  MatchEvent toEntity() {
    final matchStatus = MatchStatus.fromString(status);

    return switch (type) {
      'GOAL' => GoalEvent(
        matchId: matchId,
        minute: minute,
        team: team,
        player: player,
        timestamp: timestamp,
        status: matchStatus,
        homeScore: homeScore,
        awayScore: awayScore,
      ),
      'YELLOW_CARD' => YellowCardEvent(
        matchId: matchId,
        minute: minute,
        team: team,
        player: player,
        timestamp: timestamp,
        status: matchStatus,
      ),
      'RED_CARD' => RedCardEvent(
        matchId: matchId,
        minute: minute,
        team: team,
        player: player,
        timestamp: timestamp,
        status: matchStatus,
      ),
      'SUBSTITUTION' => SubstitutionEvent(
        matchId: matchId,
        minute: minute,
        team: team,
        player: player,
        timestamp: timestamp,
        status: matchStatus,
      ),
      'MINUTE_UPDATE' => MinuteUpdateEvent(
        matchId: matchId,
        minute: minute,
        team: team,
        player: player,
        timestamp: timestamp,
        status: matchStatus,
      ),
      _ => throw ArgumentError('Unknown event type: $type'),
    };
  }
}
