import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';
import 'package:kuru_mobile/design/widgets/k_checkbox.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/features/register/password_strength.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _termsAccepted = false;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.isEmpty) {
      setState(() => _errorMessage = l.loginErrorBadCredentials);
      return;
    }
    final pw = passwordStrength(_password.text);
    if (pw.bars < 2) {
      setState(() => _errorMessage = l.registerErrorWeakPassword);
      return;
    }
    if (!_termsAccepted) return; // CTA disabled by terms checkbox

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final repo = ref.read(authRepositoryProvider);
    final r = await repo.signUp(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
    if (!mounted) return;
    switch (r) {
      case ApiSuccess<void>():
        // Re-run bootstrap; router will route us to /create-org (zero orgs)
        ref.invalidate(appBootstrapProvider);
      case ApiFailure<void>(:final err):
        setState(() {
          _submitting = false;
          _errorMessage = switch (err) {
            BadRequestException(code: 'EMAIL_EXISTS') =>
              l.registerErrorEmailExists,
            NetworkException() => l.loginErrorNetwork,
            _ => l.loginErrorGeneric,
          };
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final canSubmit = _termsAccepted && !_submitting;

    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const AuthLogo(small: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l.registerTitle,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.55,
                                color: c.textPrimary,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.registerSubtitle,
                              style: TextStyle(fontSize: 12, color: c.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  KFormField(
                    label: l.fieldFullName,
                    controller: _name,
                    icon: const Icon(Icons.person_outline),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
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
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 8),
                  PasswordStrengthMeter(password: _password.text),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KCheckbox(
                        value: _termsAccepted,
                        onChanged: (v) => setState(() => _termsAccepted = v),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: c.textSecondary,
                                height: 1.45,
                              ),
                              children: [
                                TextSpan(text: '${_termsPrefix(l)} '),
                                TextSpan(
                                  text: l.registerTermsTos,
                                  style: TextStyle(
                                    color: c.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' ${_termsConjunction(l)} '),
                                TextSpan(
                                  text: l.registerTermsPrivacy,
                                  style: TextStyle(
                                    color: c.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: c.dangerSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(fontSize: 13, color: c.danger),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  KPrimaryBtn(
                    fullWidth: true,
                    icon: const Icon(Icons.arrow_outward),
                    onPressed: canSubmit ? _submit : null,
                    child: Text(l.registerCta),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${l.registerFooterHasAccount} ',
                          style: TextStyle(fontSize: 13, color: c.textMuted),
                        ),
                        Text(
                          l.registerFooterLogin,
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

  String _termsPrefix(AppLocalizations l) {
    // Split the "I agree to {tos} and {privacy}." string into a prefix.
    // For en/vi the part before {tos} is everything up to the first
    // placeholder. We compute it once at build time.
    final tpl = l.registerTerms('__TOS__', '__PRIV__');
    final idx = tpl.indexOf('__TOS__');
    return idx > 0 ? tpl.substring(0, idx).trimRight() : '';
  }

  String _termsConjunction(AppLocalizations l) {
    final tpl = l.registerTerms('__TOS__', '__PRIV__');
    final start = tpl.indexOf('__TOS__') + '__TOS__'.length;
    final end = tpl.indexOf('__PRIV__');
    return tpl.substring(start, end).trim();
  }
}
