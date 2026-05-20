import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:local_auth/local_auth.dart';

final _secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  ),
);

final _localAuthProvider = Provider<LocalAuthentication>(
  (ref) => LocalAuthentication(),
);

final biometricRepositoryProvider = Provider<BiometricRepository>(
  (ref) => BiometricRepository(
    auth: ref.read(_localAuthProvider),
    storage: ref.read(_secureStorageProvider),
  ),
);

final biometricEnabledProvider = FutureProvider<bool>((ref) async {
  return ref.read(biometricRepositoryProvider).isEnabled();
});

final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  return ref.read(biometricRepositoryProvider).canCheckBiometrics();
});
