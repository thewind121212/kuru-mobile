import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders logo + spinner', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider
              .overrideWith((ref) async => const BootstrapUnauthed()),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const SplashScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
