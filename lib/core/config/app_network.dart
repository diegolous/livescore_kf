abstract final class AppNetwork {
  /// Base delay unit for exponential backoff (milliseconds).
  static const int backoffBaseMs = 1000;

  /// Maximum reconnect backoff duration.
  static const Duration maxBackoff = Duration(seconds: 30);
}
