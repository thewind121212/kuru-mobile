import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/login/login_screen.dart';

Widget _harness({required List<Override> overrides}) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    locale: const Locale('vi'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
    home: const LoginScreen(),
  ),
);

void main() {
  testWidgets('LoginScreen renders email + password fields', (tester) async {
    await tester.pumpWidget(
      _harness(
        overrides: [
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => false),
        ],
      ),
    );
    await tester.pump();
    expect(find.text('Chào mừng trở lại'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsAtLeastNWidgets(1));
  });

  testWidgets('biometric button hidden when disabled', (tester) async {
    await tester.pumpWidget(
      _harness(
        overrides: [
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => true),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Đăng nhập bằng FaceID / Vân tay'), findsNothing);
  });

  testWidgets('biometric button visible when enabled + available', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        overrides: [
          biometricEnabledProvider.overrideWith((ref) async => true),
          biometricAvailableProvider.overrideWith((ref) async => true),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Đăng nhập bằng FaceID / Vân tay'), findsOneWidget);
  });
}
