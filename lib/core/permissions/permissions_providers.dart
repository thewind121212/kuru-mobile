import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/core/permissions/permissions_repository.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';

final permissionsRepositoryProvider = Provider<PermissionsRepository>(
  (ref) => PermissionsRepository(ref.read(dioProvider)),
);

final myPermissionsProvider = FutureProvider<ResolvedPermissions>((ref) async {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) {
    throw StateError('myPermissionsProvider read before orgId is set');
  }
  final result = await ref
      .read(permissionsRepositoryProvider)
      .getMyPermissions(orgId);
  return switch (result) {
    ApiSuccess<ResolvedPermissions>(:final data) => data,
    ApiFailure<ResolvedPermissions>(:final err) => throw err,
  };
});
