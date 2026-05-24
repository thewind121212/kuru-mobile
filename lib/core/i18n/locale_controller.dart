import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/main.dart';

/// User-selected locale override.
///
/// State is `Locale?`. `null` means "follow the OS" — fed into
/// `MaterialApp.router(locale:)` as null, which makes Flutter pick the
/// best match for the device's reported locale. First run defaults to
/// Vietnamese because that is the app's primary market; the user can
/// still pick Auto, Vietnamese, or English from Settings.
class LocaleController extends Notifier<Locale?> {
  static const _key = 'app_locale';

  /// The two languages the app ships translations for. The picker UI
  /// surfaces these plus an "Auto" option that maps to `null` state.
  static const supported = <Locale>[Locale('vi'), Locale('en')];

  @override
  Locale? build() {
    final code = ref.read(sharedPrefsProvider).getString(_key);
    if (code == null) return const Locale('vi');
    // Treat explicit 'auto' as "follow the OS" → null locale.
    if (code == 'auto') return null;
    for (final loc in supported) {
      if (loc.languageCode == code) return loc;
    }
    return null;
  }

  Future<void> setLocale(Locale? loc) async {
    final prefs = ref.read(sharedPrefsProvider);
    if (loc == null) {
      await prefs.setString(_key, 'auto');
    } else {
      await prefs.setString(_key, loc.languageCode);
    }
    state = loc;
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);
