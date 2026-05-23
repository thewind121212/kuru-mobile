import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';
import 'package:kuru_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('default locale is Vietnamese', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    expect(container.read(localeControllerProvider)?.languageCode, 'vi');
  });

  test('persists chosen locale across reads', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('en'));
    expect(prefs.getString('app_locale'), 'en');
    expect(container.read(localeControllerProvider)?.languageCode, 'en');
  });

  test('explicit auto resets to null and persists "auto"', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app_locale': 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    expect(container.read(localeControllerProvider)?.languageCode, 'en');
    await container.read(localeControllerProvider.notifier).setLocale(null);
    expect(prefs.getString('app_locale'), 'auto');
    expect(container.read(localeControllerProvider), isNull);
  });
}
