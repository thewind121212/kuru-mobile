import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/scanner/k_barcode_scan_button.dart';

void main() {
  Widget wrap(Widget child, {List<NavigatorObserver> observers = const []}) {
    return MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      navigatorObservers: observers,
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders icon with semantics label', (t) async {
    await t.pumpWidget(wrap(KBarcodeScanButton(onScan: (_) {})));
    expect(find.bySemanticsLabel('Quét mã vạch'), findsWidgets);
  });

  testWidgets('pushes scanner route on tap', (t) async {
    var pushed = false;
    await t.pumpWidget(
      wrap(
        KBarcodeScanButton(onScan: (_) {}),
        observers: [_PushObserver(() => pushed = true)],
      ),
    );

    await t.tap(find.byType(KBarcodeScanButton));
    await t.pump();

    expect(pushed, isTrue);
  });
}

class _PushObserver extends NavigatorObserver {
  _PushObserver(this.onPush);

  final VoidCallback onPush;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is MaterialPageRoute) onPush();
    super.didPush(route, previousRoute);
  }
}
