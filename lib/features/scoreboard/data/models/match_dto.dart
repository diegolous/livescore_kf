import '../../domain/entities/match.dart';
import '../../domain/enums/match_status.dart';

class MatchDto {
  final String id;
  final String home;
  final String away;
  final int homeScore;
  final int awayScore;
  final int minute;
  final String status;

  const MatchDto({
    required this.id,
    required this.home,
    required this.away,
    required this.homeScore,
    required this.awayScore,
    required this.minute,
    required this.status,
  });

  factory MatchDto.fromJson(Map<String, dynamic> json) {
    return MatchDto(
      id: json['id'] as String,
      home: json['home'] as String,
      away: json['away'] as String,
      homeScore: json['homeScore'] as int,
      awayScore: json['awayScore'] as int,
      minute: json['minute'] as int,
      status: json['status'] as String,
    );
  }

  Match toEntity() {
    return Match(
      id: id,
      homeTeam: home,
      awayTeam: away,
      homeScore: homeScore,
      awayScore: awayScore,
      minute: minute,
      status: MatchStatus.fromString(status),
    );
  }
}
