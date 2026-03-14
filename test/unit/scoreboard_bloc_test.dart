import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:livescore_kf/features/scoreboard/domain/entities/match.dart';
import 'package:livescore_kf/features/scoreboard/domain/entities/match_event.dart';
import 'package:livescore_kf/features/scoreboard/domain/enums/connection_status.dart';
import 'package:livescore_kf/features/scoreboard/domain/enums/match_status.dart';
import 'package:livescore_kf/features/scoreboard/domain/usecases/watch_scoreboard.dart';
import 'package:livescore_kf/features/scoreboard/presentation/bloc/scoreboard_bloc.dart';
import 'package:livescore_kf/features/scoreboard/presentation/bloc/scoreboard_event.dart';
import 'package:livescore_kf/features/scoreboard/presentation/bloc/scoreboard_state.dart';

class MockWatchScoreboard extends Mock implements WatchScoreboard {}

void main() {
  late MockWatchScoreboard mockWatchScoreboard;
  late StreamController<List<Match>> matchesController;
  late StreamController<MatchEvent> eventsController;
  late StreamController<ConnectionStatus> connectionController;

  setUp(() {
    mockWatchScoreboard = MockWatchScoreboard();
    matchesController = StreamController<List<Match>>.broadcast();
    eventsController = StreamController<MatchEvent>.broadcast();
    connectionController = StreamController<ConnectionStatus>.broadcast();

    when(() => mockWatchScoreboard.matches)
        .thenAnswer((_) => matchesController.stream);
    when(() => mockWatchScoreboard.events)
        .thenAnswer((_) => eventsController.stream);
    when(() => mockWatchScoreboard.connectionStatus)
        .thenAnswer((_) => connectionController.stream);
    when(() => mockWatchScoreboard.connect()).thenAnswer((_) async {});
    when(() => mockWatchScoreboard.disconnect()).thenAnswer((_) async {});
  });

  tearDown(() {
    matchesController.close();
    eventsController.close();
    connectionController.close();
  });

  group('ScoreboardBloc', () {
    const arsenalChelsea = Match(
      id: 'match_1',
      homeTeam: 'Arsenal',
      awayTeam: 'Chelsea',
      homeScore: 0,
      awayScore: 0,
      minute: 10,
      status: MatchStatus.live,
    );

    blocTest<ScoreboardBloc, ScoreboardState>(
      'emits updated matches when snapshot is received',
      build: () => ScoreboardBloc(mockWatchScoreboard),
      act: (bloc) async {
        bloc.add(const ScoreboardStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        matchesController.add([arsenalChelsea]);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        ScoreboardState(matches: {arsenalChelsea.id: arsenalChelsea}),
      ],
    );

    blocTest<ScoreboardBloc, ScoreboardState>(
      'emits state with lastGoalEvent when GOAL event is received',
      build: () => ScoreboardBloc(mockWatchScoreboard),
      act: (bloc) async {
        bloc.add(const ScoreboardStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final goalEvent = GoalEvent(
          matchId: 'match_1',
          minute: 25,
          team: 'Arsenal',
          player: 'Player 7',
          timestamp: DateTime(2024, 1, 1),
          status: MatchStatus.live,
          homeScore: 1,
          awayScore: 0,
        );
        eventsController.add(goalEvent);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ScoreboardState>().having(
          (s) => s.lastGoalEvent,
          'lastGoalEvent',
          isA<GoalEvent>()
              .having((e) => e.homeScore, 'homeScore', 1)
              .having((e) => e.awayScore, 'awayScore', 0),
        ),
      ],
    );

    blocTest<ScoreboardBloc, ScoreboardState>(
      'emits connection status changes',
      build: () => ScoreboardBloc(mockWatchScoreboard),
      act: (bloc) async {
        bloc.add(const ScoreboardStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        connectionController.add(ConnectionStatus.connected);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const ScoreboardState(connectionStatus: ConnectionStatus.connected),
      ],
    );
  });
}
