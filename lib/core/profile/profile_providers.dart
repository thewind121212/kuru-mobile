import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/core/profile/profile_repository.dart';
import 'package:kuru_mobile/core/profile/security_status.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.read(dioProvider)),
);

final securityStatusProvider = FutureProvider<SecurityStatus>((ref) async {
  return ref.watch(profileRepositoryProvider).getSecurityStatus().unwrap();
});
