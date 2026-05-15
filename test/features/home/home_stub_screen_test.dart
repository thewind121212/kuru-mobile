import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/home/home_stub_screen.dart';

void main() {
  testWidgets('HomeStubScreen renders authenticated state', (tester) async {
    const user = UserInfo(
      email: 'test@x.com',
      orgInfos: <OrgInfo>[OrgInfo(id: 'o1', name: 'Test Org', role: 'Chủ sở hữu')],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider
              .overrideWith((ref) async => const BootstrapAuthed(user)),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const HomeStubScreen(),
        ),
      ),
    );
    // pumpAndSettle would time out because KPrimaryBtn has a repeating shine
    // animation.  Two pumps are enough: first resolves the FutureProvider,
    // second rebuilds the widget tree with the authed state.
    await tester.pump();
    await tester.pump();
    expect(find.text('Đã đăng nhập'), findsOneWidget);
  });
}
