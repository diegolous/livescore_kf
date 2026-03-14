import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:livescore_kf/features/scoreboard/data/models/match_dto.dart';
import 'package:livescore_kf/features/scoreboard/data/models/match_event_dto.dart';
import 'package:livescore_kf/features/scoreboard/domain/entities/match_event.dart';
import 'package:livescore_kf/features/scoreboard/domain/enums/match_status.dart';

void main() {
  group('MatchEventDto', () {
    test('parses GOAL event from JSON correctly', () {
      final json = {
        'type': 'GOAL',
        'matchId': 'match_1',
        'minute': 25,
        'team': 'Arsenal',
        'player': 'Player 7',
        'homeScore': 1,
        'awayScore': 0,
        'status': 'LIVE',
        'timestamp': '2024-01-01T12:00:00.000Z',
      };

      final dto = MatchEventDto.fromJson(json);
      final event = dto.toEntity();

      expect(event, isA<GoalEvent>());
      final goal = event as GoalEvent;
      expect(goal.matchId, 'match_1');
      expect(goal.minute, 25);
      expect(goal.team, 'Arsenal');
      expect(goal.player, 'Player 7');
      expect(goal.homeScore, 1);
      expect(goal.awayScore, 0);
    });

    test('parses YELLOW_CARD event from JSON correctly', () {
      final json = {
        'type': 'YELLOW_CARD',
        'matchId': 'match_2',
        'minute': 34,
        'team': 'Barcelona',
        'player': 'Player 5',
        'homeScore': 1,
        'awayScore': 1,
        'status': 'LIVE',
        'timestamp': '2024-01-01T12:05:00.000Z',
      };

      final dto = MatchEventDto.fromJson(json);
      final event = dto.toEntity();

      expect(event, isA<YellowCardEvent>());
      expect(event.matchId, 'match_2');
      expect(event.team, 'Barcelona');
    });

    test('parses RED_CARD event from JSON correctly', () {
      final json = {
        'type': 'RED_CARD',
        'matchId': 'match_1',
        'minute': 60,
        'team': 'Chelsea',
        'player': 'Player 3',
        'homeScore': 1,
        'awayScore': 0,
        'status': 'LIVE',
        'timestamp': '2024-01-01T12:30:00.000Z',
      };

      final dto = MatchEventDto.fromJson(json);
      final event = dto.toEntity();

      expect(event, isA<RedCardEvent>());
    });

    test('parses SUBSTITUTION event from JSON correctly', () {
      final json = {
        'type': 'SUBSTITUTION',
        'matchId': 'match_1',
        'minute': 65,
        'team': 'Arsenal',
        'player': 'Player 11',
        'homeScore': 1,
        'awayScore': 0,
        'status': 'LIVE',
        'timestamp': '2024-01-01T12:35:00.000Z',
      };

      final dto = MatchEventDto.fromJson(json);
      final event = dto.toEntity();

      expect(event, isA<SubstitutionEvent>());
    });

    test('parses MINUTE_UPDATE event from JSON correctly', () {
      final json = {
        'type': 'MINUTE_UPDATE',
        'matchId': 'match_1',
        'minute': 45,
        'team': 'Arsenal',
        'player': 'Player 1',
        'homeScore': 1,
        'awayScore': 0,
        'status': 'LIVE',
        'timestamp': '2024-01-01T12:20:00.000Z',
      };

      final dto = MatchEventDto.fromJson(json);
      final event = dto.toEntity();

      expect(event, isA<MinuteUpdateEvent>());
    });

    test('parses raw JSON string end-to-end', () {
      const rawJson =
          '{"type":"GOAL","matchId":"match_1","minute":30,"team":"Arsenal","player":"Player 9","homeScore":2,"awayScore":0,"status":"LIVE","timestamp":"2024-01-01T12:15:00.000Z"}';

      final map = jsonDecode(rawJson) as Map<String, dynamic>;
      final dto = MatchEventDto.fromJson(map);
      final event = dto.toEntity();

      expect(event, isA<GoalEvent>());
      expect((event as GoalEvent).homeScore, 2);
    });
  });

  group('MatchDto', () {
    test('parses match from JSON and maps to entity', () {
      final json = {
        'id': 'match_1',
        'home': 'Arsenal',
        'away': 'Chelsea',
        'homeScore': 0,
        'awayScore': 0,
        'minute': 0,
        'status': 'LIVE',
      };

      final dto = MatchDto.fromJson(json);
      final match = dto.toEntity();

      expect(match.id, 'match_1');
      expect(match.homeTeam, 'Arsenal');
      expect(match.awayTeam, 'Chelsea');
      expect(match.homeScore, 0);
      expect(match.awayScore, 0);
      expect(match.minute, 0);
      expect(match.status, MatchStatus.live);
      expect(match.events, isEmpty);
    });

    test('parses FINISHED match status correctly', () {
      final json = {
        'id': 'match_4',
        'home': 'Juventus',
        'away': 'AC Milan',
        'homeScore': 2,
        'awayScore': 1,
        'minute': 90,
        'status': 'FINISHED',
      };

      final dto = MatchDto.fromJson(json);
      final match = dto.toEntity();

      expect(match.status, MatchStatus.finished);
      expect(match.homeScore, 2);
    });
  });
}
