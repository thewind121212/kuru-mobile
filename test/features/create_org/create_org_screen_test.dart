import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/create_org/create_org_screen.dart';

void main() {
  testWidgets('CreateOrgScreen renders title + business name field',
      (tester) async {
    const user = UserInfo(email: 'a@b.com');
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
          home: const CreateOrgScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Tạo cửa hàng của bạn'), findsOneWidget);
    expect(find.text('Tên doanh nghiệp'), findsOneWidget);
  });
}
