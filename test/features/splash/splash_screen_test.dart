import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/env/package_info_provider.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

PackageInfo fakePackageInfo({String version = '0.2.1'}) => PackageInfo(
  appName: 'Kuru',
  packageName: 'com.kuru.kuruMobile',
  version: version,
  buildNumber: '1',
);

// Widget tests bypass the gate provider's 800ms timer by default; the timing
// behavior itself is covered in splash_gate_provider_test.dart. Per-test
// extra overrides come after these defaults and win.
Widget host(SplashScreen splash, List<Override> extraOverrides) {
  return ProviderScope(
    overrides: [
      splashGateProvider.overrideWith((ref) async => const BootstrapUnauthed()),
      packageInfoProvider.overrideWith((ref) async => fakePackageInfo()),
      ...extraOverrides,
    ],
    child: MaterialApp(
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: splash,
    ),
  );
}

void main() {
  testWidgets('SplashScreen renders logo + spinner', (tester) async {
    await tester.pumpWidget(host(const SplashScreen(), []));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SplashScreen uses the simple AuthLogo variant', (tester) async {
    await tester.pumpWidget(host(const SplashScreen(), []));
    await tester.pump();

    final logo = tester.widget<AuthLogo>(find.byType(AuthLogo));
    expect(logo.simple, isTrue);
  });

  testWidgets('SplashScreen renders the version label once info resolves', (
    tester,
  ) async {
    await tester.pumpWidget(host(const SplashScreen(), []));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('v0.2.1'), findsOneWidget);
  });

  testWidgets(
    'SplashScreen does not render version label while PackageInfo loads',
    (tester) async {
      final completer = Completer<PackageInfo>();
      addTearDown(() {
        if (!completer.isCompleted) completer.complete(fakePackageInfo());
      });

      await tester.pumpWidget(
        host(const SplashScreen(), [
          packageInfoProvider.overrideWith((ref) => completer.future),
        ]),
      );
      await tester.pump();

      expect(find.textContaining('v0.2'), findsNothing);

      completer.complete(fakePackageInfo());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    },
  );
}
