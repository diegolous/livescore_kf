import 'dart:async';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../features/scoreboard/domain/enums/connection_status.dart';
import '../config/app_network.dart';

class WebSocketClient {
  final String url;
  final Duration _maxBackoff;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  int _retryCount = 0;
  bool _disposed = false;

  final _messageController = StreamController<String>.broadcast();
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  Stream<String> get messages => _messageController.stream;
  Stream<ConnectionStatus> get connectionStatus => _statusController.stream;

  WebSocketClient({
    required this.url,
    Duration maxBackoff = AppNetwork.maxBackoff,
  }) : _maxBackoff = maxBackoff;

  Future<void> connect() async {
    if (_disposed) return;
    _statusController.add(ConnectionStatus.connecting);

    try {
      final uri = Uri.parse(url);
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      _retryCount = 0;
      _statusController.add(ConnectionStatus.connected);

      _subscription = _channel!.stream.listen(
        (data) {
          if (data is String) {
            _messageController.add(data);
          }
        },
        onError: (_) => _handleDisconnect(),
        onDone: _handleDisconnect,
        cancelOnError: true,
      );
    } catch (_) {
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    if (_disposed) return;

    _subscription?.cancel();
    _subscription = null;
    _channel = null;

    _statusController.add(ConnectionStatus.reconnecting);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;

    final delay = Duration(
      milliseconds: min(
        (pow(2, _retryCount) * AppNetwork.backoffBaseMs).toInt(),
        _maxBackoff.inMilliseconds,
      ),
    );
    _retryCount++;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (!_disposed) connect();
    });
  }

  Future<void> disconnect() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;
    _statusController.add(ConnectionStatus.disconnected);
    await _messageController.close();
    await _statusController.close();
  }
}
