import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/features/settings/profile_screen.dart';

Widget _wrap({required List<Override> overrides}) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: const ProfileScreen(),
  ),
);

void main() {
  testWidgets('shows current name and email', (tester) async {
    await tester.pumpWidget(
      _wrap(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => const BootstrapAuthed(
              UserInfo(
                email: 'linh@example.com',
                name: 'Linh Tran',
                orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm', role: 'OWNER')],
              ),
            ),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Linh Tran'), findsWidgets);
    expect(find.text('linh@example.com'), findsOneWidget);
    expect(find.text('Hồ sơ'), findsOneWidget);
  });
}
