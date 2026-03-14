import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:livescore_kf/features/scoreboard/domain/entities/match.dart';
import 'package:livescore_kf/features/scoreboard/domain/enums/connection_status.dart';
import 'package:livescore_kf/features/scoreboard/domain/enums/match_status.dart';
import 'package:livescore_kf/features/scoreboard/presentation/bloc/scoreboard_bloc.dart';
import 'package:livescore_kf/features/scoreboard/presentation/bloc/scoreboard_event.dart';
import 'package:livescore_kf/features/scoreboard/presentation/bloc/scoreboard_state.dart';
import 'package:livescore_kf/features/scoreboard/presentation/bloc/team_logo_cubit.dart';
import 'package:livescore_kf/features/scoreboard/presentation/widgets/match_card.dart';
import 'package:livescore_kf/core/services/team_logo_service.dart';

class MockScoreboardBloc
    extends MockBloc<ScoreboardEvent, ScoreboardState>
    implements ScoreboardBloc {}

class MockTeamLogoService extends Mock implements TeamLogoService {}

void main() {
  late MockScoreboardBloc mockBloc;
  late TeamLogoCubit teamLogoCubit;

  setUp(() async {
    mockBloc = MockScoreboardBloc();
    final mockLogoService = MockTeamLogoService();
    when(() => mockLogoService.getBadgeUrl(any()))
        .thenAnswer((_) async => null);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    teamLogoCubit = TeamLogoCubit(mockLogoService, prefs);
  });

  const liveMatch = Match(
    id: 'match_1',
    homeTeam: 'Arsenal',
    awayTeam: 'Chelsea',
    homeScore: 2,
    awayScore: 1,
    minute: 65,
    status: MatchStatus.live,
  );

  const finishedMatch = Match(
    id: 'match_4',
    homeTeam: 'Juventus',
    awayTeam: 'AC Milan',
    homeScore: 2,
    awayScore: 1,
    minute: 90,
    status: MatchStatus.finished,
  );

  const upcomingMatch = Match(
    id: 'match_3',
    homeTeam: 'PSG',
    awayTeam: 'Lyon',
    homeScore: 0,
    awayScore: 0,
    minute: 0,
    status: MatchStatus.upcoming,
  );

  Widget buildTestWidget(String matchId) {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ScoreboardBloc>.value(value: mockBloc),
            BlocProvider<TeamLogoCubit>.value(value: teamLogoCubit),
          ],
          child: MatchCard(matchId: matchId),
        ),
      ),
    );
  }

  group('MatchCard', () {
    testWidgets('renders team names and score for a live match',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        ScoreboardState(
          matches: {liveMatch.id: liveMatch},
          connectionStatus: ConnectionStatus.connected,
        ),
      );

      await tester.pumpWidget(buildTestWidget('match_1'));

      expect(find.text('Arsenal'), findsOneWidget);
      expect(find.text('Chelsea'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.textContaining('LIVE'), findsOneWidget);
    });

    testWidgets('renders finished match correctly', (tester) async {
      when(() => mockBloc.state).thenReturn(
        ScoreboardState(
          matches: {finishedMatch.id: finishedMatch},
          connectionStatus: ConnectionStatus.connected,
        ),
      );

      await tester.pumpWidget(buildTestWidget('match_4'));

      expect(find.text('Juventus'), findsOneWidget);
      expect(find.text('AC Milan'), findsOneWidget);
      expect(find.text('FT'), findsOneWidget);
    });

    testWidgets('renders upcoming match correctly', (tester) async {
      when(() => mockBloc.state).thenReturn(
        ScoreboardState(
          matches: {upcomingMatch.id: upcomingMatch},
          connectionStatus: ConnectionStatus.connected,
        ),
      );

      await tester.pumpWidget(buildTestWidget('match_3'));

      expect(find.text('PSG'), findsOneWidget);
      expect(find.text('Lyon'), findsOneWidget);
      expect(find.text('UPCOMING'), findsOneWidget);
    });

    testWidgets('renders nothing when match is not found', (tester) async {
      when(() => mockBloc.state).thenReturn(const ScoreboardState());

      await tester.pumpWidget(buildTestWidget('nonexistent'));

      expect(find.byType(Card), findsNothing);
    });
  });
}
