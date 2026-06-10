import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/main_shell/kuru_bottom_nav.dart';
import 'package:kuru_mobile/features/main_shell/main_shell.dart';

void main() {
  testWidgets('MainShell renders four tabs with Tabler icons', (tester) async {
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
    expect(find.text('Catalogue'), findsOneWidget);
    expect(find.text('Cashflow'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byIcon(TablerIcons.home), findsOneWidget);
    expect(find.byIcon(TablerIcons.layout_grid), findsOneWidget);
    expect(find.byIcon(TablerIcons.report_money), findsOneWidget);
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
    await tester.tap(find.text('Catalogue'));
    await tester.pump();
    expect(lastTapped, 1);
  });

  testWidgets('raised action is tappable across the visible circle', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(
          bottomNavigationBar: KuruBottomBarFrame(
            action: const Icon(TablerIcons.scan, color: Colors.white),
            actionTooltip: 'Scan',
            onActionPressed: () => taps++,
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    final actionRect = tester.getRect(find.byTooltip('Scan'));
    await tester.tapAt(actionRect.topCenter + const Offset(0, 8));
    await tester.pump();

    expect(taps, 1);
  });
}
