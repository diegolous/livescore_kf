import '../entities/match.dart';
import '../entities/match_event.dart';
import '../enums/connection_status.dart';

abstract class ScoreboardRepository {
  Stream<List<Match>> get matchesStream;
  Stream<MatchEvent> get eventsStream;
  Stream<ConnectionStatus> get connectionStatusStream;

  Future<void> connect();
  Future<void> disconnect();
}
