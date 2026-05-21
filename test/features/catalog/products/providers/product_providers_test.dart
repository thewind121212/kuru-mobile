import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/permissions/permissions_providers.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

void main() {
  group('canWriteProductsProvider', () {
    test('true when orgPerms contains product.write', () {
      final c = ProviderContainer(
        overrides: [
          myPermissionsProvider.overrideWith(
            (_) async => const ResolvedPermissions(
              orgRole: OrgRole.manager,
              orgPerms: ['product.write', 'category.write'],
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      // wait for the async provider to resolve
      return c.read(myPermissionsProvider.future).then((_) {
        expect(c.read<bool>(canWriteProductsProvider), true);
      });
    });

    test('false when orgPerms missing the key', () {
      final c = ProviderContainer(
        overrides: [
          myPermissionsProvider.overrideWith(
            (_) async => const ResolvedPermissions(
              orgRole: OrgRole.staff,
              orgPerms: ['order.read'],
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c.read(myPermissionsProvider.future).then((_) {
        expect(c.read<bool>(canWriteProductsProvider), false);
      });
    });

    test('false while permissions still loading', () {
      final c = ProviderContainer(
        overrides: [
          myPermissionsProvider.overrideWith(
            (_) => Future.delayed(
              const Duration(seconds: 5),
              () => const ResolvedPermissions(orgRole: OrgRole.staff),
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read<bool>(canWriteProductsProvider), false);
    });
  });
}
