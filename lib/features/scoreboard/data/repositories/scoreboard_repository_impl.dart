import 'dart:async';

import '../../../../core/websocket/websocket_client.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/match_event.dart';
import '../../domain/enums/connection_status.dart';
import '../../domain/repositories/scoreboard_repository.dart';
import '../datasources/websocket_scoreboard_datasource.dart';

class ScoreboardRepositoryImpl implements ScoreboardRepository {
  final WebSocketScoreboardDataSource _dataSource;
  final WebSocketClient _client;

  final Map<String, Match> _matchesMap = {};

  final _matchesController = StreamController<List<Match>>.broadcast();
  final _eventsController = StreamController<MatchEvent>.broadcast();

  StreamSubscription? _snapshotSub;
  StreamSubscription? _eventSub;

  ScoreboardRepositoryImpl({
    required WebSocketScoreboardDataSource dataSource,
    required WebSocketClient client,
  })  : _dataSource = dataSource,
        _client = client;

  @override
  Stream<List<Match>> get matchesStream => _matchesController.stream;

  @override
  Stream<MatchEvent> get eventsStream => _eventsController.stream;

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _client.connectionStatus;

  @override
  Future<void> connect() async {
    _snapshotSub = _dataSource.snapshots.listen(
      (dtos) {
        _matchesMap.clear();
        for (final dto in dtos) {
          final match = dto.toEntity();
          _matchesMap[match.id] = match;
        }
        _emitMatches();
      },
      onError: (_) {},
    );

    _eventSub = _dataSource.events.listen(
      (dto) {
        final event = dto.toEntity();
        _applyEvent(event);
        _eventsController.add(event);
        _emitMatches();
      },
      onError: (_) {},
    );

    await _dataSource.connect();
  }

  void _applyEvent(MatchEvent event) {
    final match = _matchesMap[event.matchId];
    if (match == null) return;

    final updatedEvents = [...match.events, event];

    _matchesMap[event.matchId] = switch (event) {
      GoalEvent(:final homeScore, :final awayScore) => match.copyWith(
        homeScore: homeScore,
        awayScore: awayScore,
        minute: event.minute,
        status: event.status,
        events: updatedEvents,
      ),
      MinuteUpdateEvent() => match.copyWith(
        minute: event.minute,
        status: event.status,
        events: updatedEvents,
      ),
      YellowCardEvent() || RedCardEvent() || SubstitutionEvent() =>
        match.copyWith(
          minute: event.minute,
          status: event.status,
          events: updatedEvents,
        ),
    };
  }

  void _emitMatches() {
    _matchesController.add(_matchesMap.values.toList());
  }

  @override
  Future<void> disconnect() async {
    await _snapshotSub?.cancel();
    await _eventSub?.cancel();
    await _dataSource.disconnect();
    await _matchesController.close();
    await _eventsController.close();
  }
}
