import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/core/profile/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.read(dioProvider)),
);
