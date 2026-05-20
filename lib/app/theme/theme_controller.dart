import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/main.dart';

class ThemeController extends Notifier<KuruPalette> {
  static const _key = 'app_palette';

  @override
  KuruPalette build() {
    final code = ref.read(sharedPrefsProvider).getString(_key);
    for (final p in KuruPalette.values) {
      if (p.name == code) return p;
    }
    return KuruPalette.indigo;
  }

  Future<void> setPalette(KuruPalette palette) async {
    await ref.read(sharedPrefsProvider).setString(_key, palette.name);
    state = palette;
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, KuruPalette>(
  ThemeController.new,
);

ThemeData buildKuruTheme(KuruPalette palette, Brightness brightness) {
  final c = palette.resolve(brightness);
  final scheme = ColorScheme.fromSeed(
    seedColor: c.primary,
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.textInverse,
    surface: c.surface,
    onSurface: c.textPrimary,
    error: c.danger,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.pageBg,
    extensions: [c],
    fontFamily: '.SF Pro Text',
    textTheme: ThemeData.from(
      colorScheme: scheme,
    ).textTheme.apply(bodyColor: c.textPrimary, displayColor: c.textPrimary),
  );
}
