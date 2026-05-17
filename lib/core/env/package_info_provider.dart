import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Resolves the platform's bundle info (version, build number, package name).
/// Used by `SplashScreen` for the foot-of-screen version label, and by any
/// future "About" / debug screen that wants to surface the same info.
final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});
