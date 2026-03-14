import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

abstract final class AppConfig {
  // WebSocket
  static const int wsPort = 8080;
  static const String wsHost = 'localhost';
  static const String wsHostAndroid = '10.0.2.2';

  static String get websocketUrl {
    final host = !kIsWeb && Platform.isAndroid ? wsHostAndroid : wsHost;
    return 'ws://$host:$wsPort';
  }

  // Team logo API (optional — gracefully degrades to placeholder)
  static const String logoApiHost = 'www.thesportsdb.com';
  static const String logoApiPath = '/api/v1/json/3/searchteams.php';
}
