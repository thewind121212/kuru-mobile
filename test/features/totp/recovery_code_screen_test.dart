import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/totp/recovery_code_screen.dart';

void main() {
  testWidgets('RecoveryCodeScreen renders title + recovery input',
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
          home: const RecoveryCodeScreen(),
        ),
      ),
    );
    await tester.pump();
    // "Dùng mã khôi phục" appears twice (title + CTA) — that's expected.
    expect(find.text('Dùng mã khôi phục'), findsAtLeastNWidgets(1));
    expect(find.text('XXXX-XXXX'), findsOneWidget);
  });
}
