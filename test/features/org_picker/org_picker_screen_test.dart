import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/org_picker/org_picker_screen.dart';

void main() {
  testWidgets('OrgPickerScreen lists user orgs', (tester) async {
    const user = UserInfo(
      email: 'a@b.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'o1', name: 'Shop One', role: 'Owner'),
        OrgInfo(id: 'o2', name: 'Shop Two', role: 'Manager'),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => const BootstrapAuthed(user),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const OrgPickerScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Shop One'), findsOneWidget);
    expect(find.text('Shop Two'), findsOneWidget);
    expect(find.text('Tạo tổ chức mới'), findsOneWidget);
  });
}
