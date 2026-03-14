import 'dart:async';
import 'dart:convert';

import '../../../../core/websocket/websocket_client.dart';
import '../models/match_dto.dart';
import '../models/match_event_dto.dart';

class WebSocketScoreboardDataSource {
  final WebSocketClient _client;

  final _snapshotController = StreamController<List<MatchDto>>.broadcast();
  final _eventController = StreamController<MatchEventDto>.broadcast();

  StreamSubscription<String>? _messageSubscription;

  Stream<List<MatchDto>> get snapshots => _snapshotController.stream;
  Stream<MatchEventDto> get events => _eventController.stream;

  WebSocketScoreboardDataSource(this._client);

  Future<void> connect() async {
    _messageSubscription = _client.messages.listen(
      _handleMessage,
      onError: (_) {},
    );
    await _client.connect();
  }

  void _handleMessage(String rawMessage) {
    final json = jsonDecode(rawMessage) as Map<String, dynamic>;
    final type = json['type'] as String;

    if (type == 'SNAPSHOT') {
      final matchesJson = json['matches'] as List<dynamic>;
      final matches = matchesJson
          .map((m) => MatchDto.fromJson(m as Map<String, dynamic>))
          .toList();
      _snapshotController.add(matches);
    } else {
      final eventDto = MatchEventDto.fromJson(json);
      _eventController.add(eventDto);
    }
  }

  Future<void> disconnect() async {
    await _messageSubscription?.cancel();
    await _client.disconnect();
    await _snapshotController.close();
    await _eventController.close();
  }
}
