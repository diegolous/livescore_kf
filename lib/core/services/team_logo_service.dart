import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class TeamLogoService {
  final http.Client _client;
  final Map<String, String?> _cache = {};

  TeamLogoService({http.Client? client}) : _client = client ?? http.Client();

  Future<String?> getBadgeUrl(String teamName) async {
    if (_cache.containsKey(teamName)) return _cache[teamName];

    try {
      final uri = Uri.https(
        AppConfig.logoApiHost,
        AppConfig.logoApiPath,
        {'t': teamName},
      );
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final teams = data['teams'] as List<dynamic>?;

        if (teams != null && teams.isNotEmpty) {
          final badge = teams[0]['strBadge'] as String?;
          _cache[teamName] = badge;
          return badge;
        }
      }
    } catch (_) {
      // Silently fail — we'll show the placeholder
    }

    _cache[teamName] = null;
    return null;
  }

  void dispose() {
    _client.close();
  }
}
