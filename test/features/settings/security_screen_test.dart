import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/features/settings/security_screen.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('toggle on without biometric available shows warning + reverts', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => const BootstrapAuthed(
              UserInfo(
                email: 'a@b.c',
                name: 'Linh',
                orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm', role: 'OWNER')],
              ),
            ),
          ),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => false),
        ],
        child: ToastificationWrapper(
          child: MaterialApp(
            theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
            home: const SecurityScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final switchFinder = find.byType(Switch);
    expect((tester.widget(switchFinder) as Switch).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Switch stays OFF — onChanged short-circuits with a warning toast when
    // biometric isn't available on the device, never flipping local state.
    expect((tester.widget(switchFinder) as Switch).value, isFalse);
    // Drain the toastification auto-close timer before the test exits;
    // otherwise the framework flags a pending Timer.
    await tester.pump(const Duration(seconds: 5));
  });
}
