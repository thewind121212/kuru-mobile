import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:kuru_mobile/design/auth/sign_out_pill.dart';
import 'package:kuru_mobile/design/widgets/k_glass.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';

class RecoveryCodeScreen extends ConsumerStatefulWidget {
  const RecoveryCodeScreen({super.key});

  @override
  ConsumerState<RecoveryCodeScreen> createState() => _RecoveryCodeScreenState();
}

class _RecoveryCodeScreenState extends ConsumerState<RecoveryCodeScreen> {
  final _controller = TextEditingController();
  bool _submitting = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final l = AppLocalizations.of(context);
    final code = _controller.text.trim().toUpperCase();
    if (code.length < 8) return;
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final repo = ref.read(authRepositoryProvider);
    final r = await repo.useRecoveryCode(code: code);
    if (!mounted) return;
    switch (r) {
      case ApiSuccess<TotpVerifyResult>(:final data):
        switch (data) {
          case TotpOk():
            ref.invalidate(appBootstrapProvider);
          case TotpWrongCode():
            setState(() {
              _submitting = false;
              _errorText = l.totpRecoveryFailed;
            });
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
    ref.read(orgIdOverrideProvider.notifier).clear();
    ref.invalidate(appBootstrapProvider);
  }

  Future<void> _confirmSignOut() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.totpSignOut),
        content: Text(l.totpSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.totpSignOut),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await _signOut();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final hasError = _errorText != null;
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: SignOutPill(
                      label: l.commonSignOut,
                      onTap: _confirmSignOut,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: c.primarySoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.vpn_key_outlined,
                      size: 28,
                      color: c.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.totpRecoveryTitle,
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
                    l.totpRecoveryDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: c.textMuted),
                  ),
                  const SizedBox(height: 32),
                  KGlass(
                    borderRadius: BorderRadius.circular(14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    borderColor: hasError ? c.danger : null,
                    borderWidth: hasError ? 1.5 : null,
                    child: TextField(
                      controller: _controller,
                      enabled: !_submitting,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('[A-Za-z0-9-]'),
                        ),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        letterSpacing: 6,
                        color: c.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: l.totpRecoveryPlaceholder,
                        hintStyle: TextStyle(
                          color: c.textMuted,
                          letterSpacing: 4,
                          fontFamily: 'monospace',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      onChanged: (_) {
                        if (hasError) setState(() => _errorText = null);
                      },
                      onSubmitted: (_) => _verify(),
                    ),
                  ),
                  if (hasError) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 14, color: c.danger),
                        const SizedBox(width: 4),
                        Text(
                          _errorText!,
                          style: TextStyle(
                            fontSize: 13,
                            color: c.danger,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  KPrimaryBtn(
                    fullWidth: true,
                    icon: const Icon(Icons.arrow_outward),
                    onPressed: _submitting ? null : _verify,
                    child: Text(l.totpUseRecoveryButton),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => context.go('/totp'),
                    child: Text(
                      l.totpBackToAuthenticator,
                      style: TextStyle(
                        color: c.textSecondary,
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
