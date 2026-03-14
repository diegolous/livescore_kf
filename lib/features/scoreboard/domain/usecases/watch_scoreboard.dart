import '../entities/match.dart';
import '../entities/match_event.dart';
import '../enums/connection_status.dart';
import '../repositories/scoreboard_repository.dart';

class WatchScoreboard {
  final ScoreboardRepository _repository;

  const WatchScoreboard(this._repository);

  Stream<List<Match>> get matches => _repository.matchesStream;
  Stream<MatchEvent> get events => _repository.eventsStream;
  Stream<ConnectionStatus> get connectionStatus =>
      _repository.connectionStatusStream;

  Future<void> connect() => _repository.connect();
  Future<void> disconnect() => _repository.disconnect();
}
