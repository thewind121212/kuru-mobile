import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthCancelled implements Exception {
  const BiometricAuthCancelled();
}

class BiometricCredentials {
  const BiometricCredentials({required this.email, required this.password});
  final String email;
  final String password;
}

class BiometricRepository {
  BiometricRepository({
    required LocalAuthentication auth,
    required FlutterSecureStorage storage,
  }) : _auth = auth,
       _storage = storage;

  static const _emailKey = 'biometric_email';
  static const _passwordKey = 'biometric_password';

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  Future<bool> canCheckBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      return _auth.canCheckBiometrics;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> isEnabled() async {
    final email = await _storage.read(key: _emailKey);
    return email != null && email.isNotEmpty;
  }

  Future<void> enable({required String email, required String password}) async {
    final ok = await _auth.authenticate(
      localizedReason: 'Bật đăng nhập bằng FaceID / vân tay',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    if (!ok) throw const BiometricAuthCancelled();
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<void> disable() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }

  Future<BiometricCredentials?> unlock() async {
    final ok = await _auth.authenticate(
      localizedReason: 'Đăng nhập bằng FaceID / vân tay',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    if (!ok) return null;
    final email = await _storage.read(key: _emailKey);
    final password = await _storage.read(key: _passwordKey);
    if (email == null || password == null) return null;
    return BiometricCredentials(email: email, password: password);
  }
}
