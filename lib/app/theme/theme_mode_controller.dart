import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/main.dart';

/// User-facing theme mode (Auto / Light / Dark). Persisted to
/// SharedPreferences so the choice survives app restarts.
///
/// `ThemeMode.system` is the default and means "follow the OS". The
/// caller is expected to feed this into `MaterialApp.router(themeMode:)`
/// while supplying both `theme:` (light) and `darkTheme:` (dark).
class ThemeModeController extends Notifier<ThemeMode> {
  static const _key = 'app_theme_mode';

  @override
  ThemeMode build() {
    final code = ref.read(sharedPrefsProvider).getString(_key);
    return switch (code) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    final code = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await ref.read(sharedPrefsProvider).setString(_key, code);
    state = mode;
  }
}

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
