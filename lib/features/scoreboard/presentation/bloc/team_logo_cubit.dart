import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/team_logo_service.dart';

class TeamLogoCubit extends Cubit<Map<String, String?>> {
  static const _cacheKey = 'team_logo_urls';

  final TeamLogoService _service;
  final SharedPreferences _prefs;
  final Set<String> _requested = {};

  TeamLogoCubit(this._service, this._prefs) : super(_loadCache(_prefs));

  static Map<String, String?> _loadCache(SharedPreferences prefs) {
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return const {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v as String?));
  }

  void _persistCache() {
    _prefs.setString(_cacheKey, jsonEncode(state));
  }

  void fetchLogo(String teamName) {
    if (_requested.contains(teamName)) return;
    _requested.add(teamName);

    if (state.containsKey(teamName)) return;

    _service.getBadgeUrl(teamName).then((url) {
      if (url != null && !isClosed) {
        final updated = Map<String, String?>.of(state);
        updated[teamName] = url;
        emit(updated);
        _persistCache();
      }
    }).onError((_, _) {});
  }

  Future<void> prefetchAll(List<String> teamNames) async {
    final missing = teamNames.where((t) => !state.containsKey(t)).toList();
    if (missing.isEmpty) return;

    final futures = missing.map((name) {
      _requested.add(name);
      return _service.getBadgeUrl(name)
          .then((url) => MapEntry(name, url))
          .onError((_, _) => MapEntry(name, null));
    });

    final results = await Future.wait(futures);
    final updated = Map<String, String?>.of(state);
    for (final entry in results) {
      if (entry.value != null) {
        updated[entry.key] = entry.value;
      }
    }

    if (!isClosed) {
      emit(updated);
      _persistCache();
    }
  }

  String? getBadgeUrl(String teamName) {
    fetchLogo(teamName);
    return state[teamName];
  }
}
