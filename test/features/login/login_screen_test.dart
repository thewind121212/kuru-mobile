import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/login/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders email + password fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Chào mừng trở lại'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsAtLeastNWidgets(1));
  });
}
