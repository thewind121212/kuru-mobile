import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/core/profile/profile_repository.dart';
import 'package:kuru_mobile/core/profile/security_status.dart';
import 'package:kuru_mobile/features/settings/security_screen.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('toggle on without biometric available shows warning + reverts', (
    tester,
  ) async {
    final repo = _FakeProfileRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(repo),
          appBootstrapProvider.overrideWith(
            (ref) async => const BootstrapAuthed(
              UserInfo(
                email: 'a@b.c',
                name: 'Linh',
                orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm', role: 'OWNER')],
              ),
            ),
          ),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => false),
        ],
        child: ToastificationWrapper(
          child: MaterialApp(
            theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SecurityScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final switchFinder = find.byType(Switch);
    expect((tester.widget(switchFinder) as Switch).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Switch stays OFF — onChanged short-circuits with a warning toast when
    // biometric isn't available on the device, never flipping local state.
    expect((tester.widget(switchFinder) as Switch).value, isFalse);
    // Drain the toastification auto-close timer before the test exits;
    // otherwise the framework flags a pending Timer.
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('enables 2FA and displays recovery codes', (tester) async {
    final repo = _FakeProfileRepository();
    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Xác thực 2 lớp'));
    await tester.pumpAndSettle();
    expect(find.text('Bật 2FA'), findsOneWidget);

    await tester.ensureVisible(find.text('Bật 2FA'));
    await tester.pump();
    await tester.tap(find.text('Bật 2FA'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'pw123456');
    await tester.ensureVisible(find.text('Tiếp tục'));
    await tester.pump();
    await tester.tap(find.text('Tiếp tục'));
    await tester.pumpAndSettle();

    expect(find.text('Khóa thủ công'), findsOneWidget);
    expect(find.text('SECRET'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.ensureVisible(find.text('Xác minh'));
    await tester.pump();
    await tester.tap(find.text('Xác minh'));
    await tester.pumpAndSettle();

    expect(find.text('AAAA-BBBB'), findsOneWidget);
    expect(find.text('CCCC-DDDD'), findsOneWidget);
    expect(repo.createdPassword, 'pw123456');
    expect(repo.verifiedCode, '123456');

    await tester.tap(find.text('Đã lưu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(repo.status.totpEnabled, isTrue);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('disables 2FA with password and authenticator code', (
    tester,
  ) async {
    final repo = _FakeProfileRepository(
      initialStatus: const SecurityStatus(
        totpEnabled: true,
        recoveryCodesRemaining: 10,
      ),
    );
    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Xác thực 2 lớp'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tắt 2FA').last);
    await tester.pump();
    await tester.tap(find.text('Tắt 2FA').last);
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'pw123456');
    await tester.enterText(fields.at(1), '654321');
    await tester.ensureVisible(find.text('Tắt 2FA').last);
    await tester.pump();
    await tester.tap(find.text('Tắt 2FA').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(repo.disabledPassword, 'pw123456');
    expect(repo.disabledCode, '654321');
    expect(repo.status.totpEnabled, isFalse);

    await tester.pump(const Duration(seconds: 5));
  });
}

Widget _harness(_FakeProfileRepository repo) {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(repo),
      appBootstrapProvider.overrideWith(
        (ref) async => const BootstrapAuthed(
          UserInfo(
            email: 'a@b.c',
            name: 'Linh',
            orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm', role: 'OWNER')],
          ),
        ),
      ),
      biometricEnabledProvider.overrideWith((ref) async => false),
      biometricAvailableProvider.overrideWith((ref) async => true),
    ],
    child: ToastificationWrapper(
      child: MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SecurityScreen(),
      ),
    ),
  );
}

class _FakeProfileRepository extends ProfileRepository {
  _FakeProfileRepository({
    SecurityStatus initialStatus = const SecurityStatus(),
  }) : status = initialStatus,
       super(Dio());

  SecurityStatus status;
  String? createdPassword;
  String? verifiedCode;
  String? disabledPassword;
  String? disabledCode;

  @override
  Future<ApiResult<SecurityStatus>> getSecurityStatus() async {
    return ApiResult.success(status);
  }

  @override
  Future<ApiResult<TotpDeviceSetup>> createTotpDevice({
    required String password,
  }) async {
    createdPassword = password;
    return ApiResult.success(
      const TotpDeviceSetup(
        deviceName: 'device-1',
        secret: 'SECRET',
        qrCodeString: 'otpauth://totp/TuiBuonBan:test?secret=SECRET',
      ),
    );
  }

  @override
  Future<ApiResult<TotpDeviceVerification>> verifyTotpDevice({
    required String deviceName,
    required String code,
  }) async {
    verifiedCode = code;
    status = status.copyWith(totpEnabled: true, recoveryCodesRemaining: 2);
    return ApiResult.success(
      const TotpDeviceVerification(
        verified: true,
        recoveryCodes: ['AAAA-BBBB', 'CCCC-DDDD'],
      ),
    );
  }

  @override
  Future<ApiResult<void>> disableTotp({
    required String password,
    required String totpCode,
  }) async {
    disabledPassword = password;
    disabledCode = totpCode;
    status = status.copyWith(totpEnabled: false, recoveryCodesRemaining: 0);
    return ApiResult.success(null);
  }
}
