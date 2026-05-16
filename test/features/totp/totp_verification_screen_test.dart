import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/totp/totp_verification_screen.dart';

void main() {
  testWidgets('TotpVerificationScreen renders title + 6 OTP boxes',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const TotpVerificationScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Xác thực hai yếu tố'), findsOneWidget);
    // 6 TextFields = 6 OTP boxes.
    expect(find.byType(TextField), findsNWidgets(6));
  });
}
