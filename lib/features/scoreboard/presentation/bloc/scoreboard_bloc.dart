import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/match.dart';
import '../../domain/entities/match_event.dart';
import '../../domain/usecases/watch_scoreboard.dart';
import 'scoreboard_event.dart';
import 'scoreboard_state.dart';

class ScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  final WatchScoreboard _watchScoreboard;

  StreamSubscription? _matchesSub;
  StreamSubscription? _eventsSub;
  StreamSubscription? _connectionSub;

  ScoreboardBloc(this._watchScoreboard) : super(const ScoreboardState()) {
    on<ScoreboardStarted>(_onStarted);
    on<ScoreboardMatchesUpdated>(_onMatchesUpdated);
    on<ScoreboardMatchEventReceived>(_onMatchEventReceived);
    on<ScoreboardConnectionChanged>(_onConnectionChanged);
  }

  Future<void> _onStarted(
    ScoreboardStarted event,
    Emitter<ScoreboardState> emit,
  ) async {
    _matchesSub = _watchScoreboard.matches.listen(
      (matches) => add(ScoreboardMatchesUpdated(matches)),
      onError: (_) {},
    );

    _eventsSub = _watchScoreboard.events.listen(
      (event) => add(ScoreboardMatchEventReceived(event)),
      onError: (_) {},
    );

    _connectionSub = _watchScoreboard.connectionStatus.listen(
      (status) => add(ScoreboardConnectionChanged(status)),
      onError: (_) {},
    );

    await _watchScoreboard.connect();
  }

  void _onMatchesUpdated(
    ScoreboardMatchesUpdated event,
    Emitter<ScoreboardState> emit,
  ) {
    final matchesMap = <String, Match>{};
    for (final match in event.matches) {
      matchesMap[match.id] = match;
    }
    emit(state.copyWith(matches: matchesMap));
  }

  void _onMatchEventReceived(
    ScoreboardMatchEventReceived event,
    Emitter<ScoreboardState> emit,
  ) {
    if (event.event is GoalEvent) {
      emit(state.copyWith(lastGoalEvent: event.event));
    }
  }

  void _onConnectionChanged(
    ScoreboardConnectionChanged event,
    Emitter<ScoreboardState> emit,
  ) {
    emit(state.copyWith(connectionStatus: event.status));
  }

  @override
  Future<void> close() async {
    await _matchesSub?.cancel();
    await _eventsSub?.cancel();
    await _connectionSub?.cancel();
    await _watchScoreboard.disconnect();
    return super.close();
  }
}
