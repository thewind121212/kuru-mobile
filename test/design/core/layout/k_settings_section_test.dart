import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';

void main() {
  testWidgets('renders header + child rows in grouped card', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: const Scaffold(
          body: KSettingsSection(
            header: 'Bảo mật',
            children: [
              ListTile(title: Text('Đổi mật khẩu')),
              ListTile(title: Text('2FA')),
            ],
          ),
        ),
      ),
    );
    expect(find.text('BẢO MẬT'), findsOneWidget);
    expect(find.text('Đổi mật khẩu'), findsOneWidget);
    expect(find.text('2FA'), findsOneWidget);
  });

  testWidgets('header empty -> no header rendered', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: const Scaffold(
          body: KSettingsSection(
            header: '',
            children: [ListTile(title: Text('Đăng xuất'))],
          ),
        ),
      ),
    );
    expect(find.text(''), findsNothing);
    expect(find.text('Đăng xuất'), findsOneWidget);
  });
}
