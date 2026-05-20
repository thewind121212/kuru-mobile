import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/main_shell/main_shell.dart';

void main() {
  testWidgets('MainShell renders 3 NavigationDestinations with Tabler icons', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainShell(
          currentIndex: 0,
          onTabChanged: (_) {},
          body: const Center(child: Text('TAB_BODY')),
        ),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byIcon(TablerIcons.home), findsOneWidget);
    expect(find.byIcon(TablerIcons.layout_grid), findsOneWidget);
    expect(find.byIcon(TablerIcons.settings), findsOneWidget);
    expect(find.text('TAB_BODY'), findsOneWidget);
  });

  testWidgets('Tapping a destination calls onTabChanged', (tester) async {
    var lastTapped = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainShell(
          currentIndex: 0,
          onTabChanged: (int i) => lastTapped = i,
          body: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    expect(lastTapped, 1);
  });
}
