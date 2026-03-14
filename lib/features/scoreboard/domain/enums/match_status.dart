enum MatchStatus {
  live,
  upcoming,
  finished;

  static MatchStatus fromString(String value) {
    return switch (value.toUpperCase()) {
      'LIVE' => MatchStatus.live,
      'UPCOMING' => MatchStatus.upcoming,
      'FINISHED' => MatchStatus.finished,
      _ => throw ArgumentError('Unknown match status: $value'),
    };
  }

  String get label => switch (this) {
    MatchStatus.live => 'LIVE',
    MatchStatus.upcoming => 'UPCOMING',
    MatchStatus.finished => 'FINISHED',
  };
}
