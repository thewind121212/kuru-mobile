import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/main.dart';

class LocaleController extends Notifier<Locale> {
  static const _key = 'app_locale';
  static const supported = <Locale>[Locale('vi'), Locale('en')];

  @override
  Locale build() {
    final prefs = ref.read(sharedPrefsProvider);
    final code = prefs.getString(_key);
    if (code == null) return const Locale('vi');
    return supported.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => const Locale('vi'),
    );
  }

  Future<void> setLocale(Locale loc) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, loc.languageCode);
    state = loc;
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
