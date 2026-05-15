/// Compile-time configuration injected via `--dart-define`.
class Env {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:9190', // android emu default
  );

  /// True when running on iOS simulator — use localhost instead of 10.0.2.2.
  /// Caller sets this via dart-define if needed: `--dart-define=API_BASE_URL=http://localhost:9190`.
  static bool get hasOverride =>
      const String.fromEnvironment('API_BASE_URL').isNotEmpty;
}
