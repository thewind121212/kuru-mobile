import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('renders initials for null avatarStyle', (tester) async {
    await tester.pumpWidget(_wrap(const KAvatar(name: 'Linh Tran', size: 48)));
    expect(find.text('LT'), findsOneWidget);
  });

  testWidgets('single-name initials use first two letters', (tester) async {
    await tester.pumpWidget(_wrap(const KAvatar(name: 'Linh', size: 48)));
    expect(find.text('LI'), findsOneWidget);
  });

  testWidgets('falls back to ? when name empty', (tester) async {
    await tester.pumpWidget(_wrap(const KAvatar(name: '', size: 48)));
    expect(find.text('?'), findsOneWidget);
  });
}
