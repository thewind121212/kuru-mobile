import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/widgets/order_status_badge.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('vi'),
    home: Scaffold(body: child),
  );

  testWidgets('renders Vietnamese status labels', (tester) async {
    for (final s in OrderStatus.values) {
      await tester.pumpWidget(wrap(OrderStatusBadge(status: s)));
      await tester.pump();
    }
    // Last status pumped is cancelled
    expect(find.text('Đã hủy'), findsOneWidget);
  });
}
