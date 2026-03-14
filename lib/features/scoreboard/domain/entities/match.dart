import 'package:equatable/equatable.dart';

import '../enums/match_status.dart';
import 'match_event.dart';

class Match extends Equatable {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final int minute;
  final MatchStatus status;
  final List<MatchEvent> events;

  const Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.minute,
    required this.status,
    this.events = const [],
  });

  Match copyWith({
    String? id,
    String? homeTeam,
    String? awayTeam,
    int? homeScore,
    int? awayScore,
    int? minute,
    MatchStatus? status,
    List<MatchEvent>? events,
  }) {
    return Match(
      id: id ?? this.id,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      minute: minute ?? this.minute,
      status: status ?? this.status,
      events: events ?? this.events,
    );
  }

  @override
  List<Object?> get props => [
    id,
    homeTeam,
    awayTeam,
    homeScore,
    awayScore,
    minute,
    status,
    events.length,
  ];
}
