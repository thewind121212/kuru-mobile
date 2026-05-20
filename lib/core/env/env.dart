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

  /// Public MinIO / S3 base URL for image buckets (user-avatar, product
  /// images, etc.). The web's equivalent is `VITE_BASE_PUBLIC_IMAGE_URL`
  /// (defaults to `http://localhost:9100`). Mobile on a physical device
  /// must point at the dev machine's LAN IP, e.g.
  /// `--dart-define=IMAGE_BASE_URL=http://192.168.50.27:9100`.
  ///
  /// Falls back to swapping the API port (9190) for MinIO's default
  /// (9100) on the API_BASE_URL host so simple local setups Just Work
  /// without a second dart-define.
  static String get imageBaseUrl {
    const explicit = String.fromEnvironment('IMAGE_BASE_URL');
    if (explicit.isNotEmpty) return explicit;
    return apiBaseUrl
        .replaceFirst(':9190', ':9100')
        .replaceFirst('://10.0.2.2', '://10.0.2.2');
  }
}
