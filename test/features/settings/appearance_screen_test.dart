import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';
import 'package:kuru_mobile/features/settings/appearance_screen.dart';
import 'package:kuru_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('tapping purple swatch updates themeControllerProvider', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const AppearanceScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(container.read(themeControllerProvider), KuruPalette.indigo);
    await tester.tap(find.byKey(const ValueKey('palette.purple')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(container.read(themeControllerProvider), KuruPalette.purple);
  });

  testWidgets('tapping English updates localeControllerProvider', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const AppearanceScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('locale.en')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(container.read(localeControllerProvider)?.languageCode, 'en');
  });
}
