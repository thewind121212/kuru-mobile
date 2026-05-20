import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';

void main() {
  group('ResolvedPermissions.fromJson', () {
    test('parses OWNER with org perms', () {
      final json = {
        'orgRole': 'OWNER',
        'orgPerms': ['member.invite', 'setting.write'],
        'perStore': <Map<String, dynamic>>[],
      };
      final p = ResolvedPermissions.fromJson(json);
      expect(p.orgRole, OrgRole.owner);
      expect(p.orgPerms, ['member.invite', 'setting.write']);
      expect(p.isOwner, isTrue);
    });

    test('parses STAFF with empty perms', () {
      final json = {
        'orgRole': 'STAFF',
        'orgPerms': <String>[],
        'perStore': <Map<String, dynamic>>[],
      };
      final p = ResolvedPermissions.fromJson(json);
      expect(p.orgRole, OrgRole.staff);
      expect(p.isOwner, isFalse);
    });

    test('unknown role falls back to staff', () {
      final p = ResolvedPermissions.fromJson({
        'orgRole': 'GUEST',
        'orgPerms': <String>[],
        'perStore': <Map<String, dynamic>>[],
      });
      expect(p.orgRole, OrgRole.staff);
    });
  });
}
