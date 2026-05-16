import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Dev affordance — long-press the logo in a debug build to reset the
  /// onboarding-seen flag and replay the carousel. No-op in release builds.
  Future<void> _devReplayOnboarding() async {
    if (!kDebugMode) return;
    await ref.read(onboardingSeenProvider.notifier).reset();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Onboarding reset — replaying flow'),
        duration: Duration(seconds: 1),
      ),
    );
    context.go('/onboarding');
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = l.loginErrorBadCredentials);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signIn(email: email, password: password);
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<void>():
        // Re-run bootstrap so router redirects us to home.
        ref.invalidate(appBootstrapProvider);
      case ApiFailure<void>(:final err):
        setState(() => _submitting = false);
        switch (err) {
          case UnauthorizedException():
            // Credential errors → inline banner (user needs to fix a field).
            setState(() => _errorMessage = l.loginErrorBadCredentials);
          case NetworkException():
            // Transient operational error → bottom SnackBar with retry.
            setState(() => _errorMessage = null);
            KNotify.networkError(
              context,
              l.loginErrorNetwork,
              onRetry: _submit,
            );
          case _:
            // Generic server / unknown error → SnackBar with retry too.
            setState(() => _errorMessage = null);
            KNotify.networkError(
              context,
              l.loginErrorGeneric,
              onRetry: _submit,
            );
        }
    }
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
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onLongPress: _devReplayOnboarding,
                              behavior: HitTestBehavior.opaque,
                              child: const AuthLogo(),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l.loginTitle,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.9,
                                color: c.textPrimary,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l.loginSubtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: c.textMuted,
                              ),
                            ),
                            const SizedBox(height: 28),
                            KFormField(
                              label: l.fieldEmail,
                              controller: _email,
                              icon: const Icon(Icons.mail_outline),
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            KFormField(
                              label: l.fieldPassword,
                              controller: _password,
                              icon: const Icon(Icons.lock_outline),
                              obscureText: true,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: c.dangerSoft,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: c.danger,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            KPrimaryBtn(
                              fullWidth: true,
                              icon: const Icon(Icons.arrow_outward),
                              onPressed: _submitting ? null : _submit,
                              child: Text(l.loginCta),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${l.loginFooterNoAccount} ',
                          style: TextStyle(fontSize: 13, color: c.textMuted),
                        ),
                        Text(
                          l.loginFooterRegister,
                          style: TextStyle(
                            fontSize: 13,
                            color: c.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
