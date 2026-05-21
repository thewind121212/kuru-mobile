import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/widgets/k_otp_input.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';

class TotpVerificationScreen extends ConsumerStatefulWidget {
  const TotpVerificationScreen({super.key});

  @override
  ConsumerState<TotpVerificationScreen> createState() =>
      _TotpVerificationScreenState();
}

class _TotpVerificationScreenState
    extends ConsumerState<TotpVerificationScreen> {
  String _code = '';
  bool _submitting = false;
  KOtpStatus _status = KOtpStatus.idle;
  String? _errorText;
  final _otpKey = GlobalKey<State<KOtpInput>>();

  Future<void> _verify() async {
    if (_code.length != 6) return;
    final l = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _errorText = null;
      _status = KOtpStatus.idle;
    });
    final repo = ref.read(authRepositoryProvider);
    final r = await repo.verifyTotpCode(code: _code);
    if (!mounted) return;
    switch (r) {
      case ApiSuccess<TotpVerifyResult>(:final data):
        switch (data) {
          case TotpOk():
            setState(() => _status = KOtpStatus.success);
            // Re-run bootstrap; router will redirect us past MFA.
            ref.invalidate(appBootstrapProvider);
          case TotpWrongCode():
            setState(() {
              _submitting = false;
              _status = KOtpStatus.error;
              _errorText = l.totpWrongCode;
              _code = '';
            });
            (_otpKey.currentState as dynamic).clear();
          case TotpRateLimited():
            setState(() => _submitting = false);
            KNotify.warning(context, l.totpRateLimited);
          case TotpSessionExpired():
            KNotify.warning(context, l.totpSessionExpired);
            await _signOut();
        }
      case ApiFailure<TotpVerifyResult>(:final err):
        setState(() => _submitting = false);
        if (err is NetworkException) {
          KNotify.networkError(context, l.loginErrorNetwork, onRetry: _verify);
        } else {
          KNotify.networkError(context, l.loginErrorGeneric, onRetry: _verify);
        }
    }
  }

  Future<void> _signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    ref.read(currentOrgIdProvider.notifier).clear();
    ref.invalidate(appBootstrapProvider);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: c.primarySoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.shield_outlined,
                      size: 28,
                      color: c.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.totpTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.totpDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: c.textMuted),
                  ),
                  const SizedBox(height: 32),
                  KOtpInput(
                    key: _otpKey,
                    status: _status,
                    enabled: !_submitting,
                    errorText: _errorText,
                    onChanged: (v) => setState(() => _code = v),
                    onCompleted: (_) => _verify(),
                  ),
                  const SizedBox(height: 24),
                  KPrimaryBtn(
                    fullWidth: true,
                    icon: const Icon(Icons.arrow_outward),
                    onPressed: _code.length == 6 && !_submitting
                        ? _verify
                        : null,
                    child: Text(l.totpVerifyButton),
                  ),
                  const SizedBox(height: 18),
                  TextButton.icon(
                    onPressed: () => context.go('/totp/recovery'),
                    icon: Icon(
                      Icons.vpn_key_outlined,
                      color: c.primary,
                      size: 16,
                    ),
                    label: Text(
                      l.totpLostDevice,
                      style: TextStyle(
                        color: c.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _signOut,
                    icon: Icon(Icons.logout, color: c.textMuted, size: 16),
                    label: Text(
                      l.totpSignOut,
                      style: TextStyle(
                        color: c.textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
