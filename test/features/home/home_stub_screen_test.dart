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
  testWidgets('HomeStubScreen renders ledger home', (tester) async {
    const user = UserInfo(
      email: 'test@x.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'o1', name: 'Test Org', role: 'Chủ sở hữu'),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => const BootstrapAuthed(user),
          ),
          currentOrgIdProvider.overrideWithValue('o1'),
          homeLedgerProvider.overrideWith(
            (ref) async => const HomeLedgerSnapshot(
              orders: [],
              totalOrders: 0,
              salesTotal: 0,
              collected: 0,
              receivable: 0,
              expenses: 0,
              expenseCount: 0,
            ),
          ),
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
    await tester.pump();
    await tester.pump();
    expect(find.text('Sổ cái'), findsOneWidget);
    expect(find.text('Chưa có giao dịch'), findsOneWidget);
  });
}
