import 'package:freezed_annotation/freezed_annotation.dart';

part 'resolved_permissions.freezed.dart';

enum OrgRole {
  owner,
  manager,
  staff;

  static OrgRole fromWire(String? wire) {
    switch (wire) {
      case 'OWNER':
        return OrgRole.owner;
      case 'MANAGER':
        return OrgRole.manager;
      case 'STAFF':
      default:
        return OrgRole.staff;
    }
  }
}

@freezed
class ResolvedPermissions with _$ResolvedPermissions {
  const factory ResolvedPermissions({
    required OrgRole orgRole,
    @Default(<String>[]) List<String> orgPerms,
  }) = _ResolvedPermissions;

  const ResolvedPermissions._();

  factory ResolvedPermissions.fromJson(Map<String, dynamic> json) {
    return ResolvedPermissions(
      orgRole: OrgRole.fromWire(json['orgRole'] as String?),
      orgPerms: (json['orgPerms'] as List<dynamic>? ?? const <dynamic>[])
          .cast<String>(),
    );
  }

  bool get isOwner => orgRole == OrgRole.owner;
}
