import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/permissions/permissions_providers.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';
import 'package:kuru_mobile/features/settings/settings_home_screen.dart';

UserInfo _user() => const UserInfo(
  email: 'linh@example.com',
  name: 'Linh Tran',
  orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm Linh', role: 'OWNER')],
);

Widget _harness({required List<Override> overrides}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SettingsHomeScreen()),
        ],
      ),
    ),
  );
}

void main() {
  testWidgets('OWNER sees Cửa hàng section', (tester) async {
    await tester.pumpWidget(
      _harness(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => BootstrapAuthed(_user()),
          ),
          myPermissionsProvider.overrideWith(
            (ref) async => const ResolvedPermissions(orgRole: OrgRole.owner),
          ),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => true),
          currentOrgIdProvider.overrideWithValue('o1'),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Cửa hàng'), findsOneWidget);
  });

  testWidgets('STAFF does not see Cửa hàng section', (tester) async {
    await tester.pumpWidget(
      _harness(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => BootstrapAuthed(_user()),
          ),
          myPermissionsProvider.overrideWith(
            (ref) async => const ResolvedPermissions(orgRole: OrgRole.staff),
          ),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => true),
          currentOrgIdProvider.overrideWithValue('o1'),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Cửa hàng'), findsNothing);
    expect(find.text('Bảo mật'), findsOneWidget);
  });
}
