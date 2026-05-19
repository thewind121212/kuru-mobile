import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/brand_action_menu.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('Edit returns BrandAction.edit', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(
      _harness(
        Builder(
          builder: (ctx) {
            capturedCtx = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    final future = showBrandActionMenu(context: capturedCtx, brandName: 'Nike');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(await future, BrandAction.edit);
  });

  testWidgets('Delete returns BrandAction.delete', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(
      _harness(
        Builder(
          builder: (ctx) {
            capturedCtx = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    final future = showBrandActionMenu(context: capturedCtx, brandName: 'Nike');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await future, BrandAction.delete);
  });
}
