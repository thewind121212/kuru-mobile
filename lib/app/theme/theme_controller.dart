import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';

/// Holds the currently selected palette. v1 hard-codes purple; the picker
/// UI lands in a future Settings spec.
class ThemeController extends Notifier<KuruPalette> {
  @override
  KuruPalette build() => KuruPalette.purple;

  void setPalette(KuruPalette p) => state = p;
}

final themeControllerProvider =
    NotifierProvider<ThemeController, KuruPalette>(ThemeController.new);

/// Build a Material `ThemeData` for the given palette + brightness.
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
    textTheme: ThemeData.from(colorScheme: scheme).textTheme.apply(
          bodyColor: c.textPrimary,
          displayColor: c.textPrimary,
        ),
  );
}
