import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/design/widgets/k_step_dots.dart';
import 'package:kuru_mobile/features/create_org/store_illustration.dart';

class CreateOrgScreen extends ConsumerStatefulWidget {
  const CreateOrgScreen({super.key});

  @override
  ConsumerState<CreateOrgScreen> createState() => _CreateOrgScreenState();
}

class _CreateOrgScreenState extends ConsumerState<CreateOrgScreen> {
  final _businessName = TextEditingController();
  final _branchName = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _businessName.dispose();
    _branchName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final orgName = _businessName.text.trim();
    final firstStoreName = _branchName.text.trim();
    if (orgName.isEmpty) {
      setState(() => _errorMessage = l.createOrgErrorNameRequired);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final repo = ref.read(authRepositoryProvider);
    // Single BE call now handles both org + first branch in one request via
    // the canonical { orgName, firstStoreName? } shape.
    final storeResult = await repo.createStore(
      orgName: orgName,
      firstStoreName: firstStoreName.isEmpty ? null : firstStoreName,
    );
    if (!mounted) return;
    switch (storeResult) {
      case ApiSuccess<String>():
        // Bootstrap will now find an org → routes to /home
        ref.invalidate(appBootstrapProvider);
      case ApiFailure<String>(:final err):
        setState(() {
          _submitting = false;
          // 4xx errors carry an actionable, user-readable BE message
          // (e.g. "Organization name must be less than 100 characters").
          // Surface verbatim. 5xx → localized fallback.
          _errorMessage = err is BadRequestException
              ? err.message
              : l.createOrgErrorServer;
        });
    }
  }

  Future<void> _logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    ref.read(currentOrgIdProvider.notifier).clear();
    ref.invalidate(appBootstrapProvider);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final email = bootstrap.maybeWhen(
      data: (s) => s is BootstrapAuthed ? s.user.email ?? '' : '',
      orElse: () => '',
    );

    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: Column(
              children: [
                // Custom auth chrome: tiny header with email + logout
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new, size: 18),
                      const Spacer(),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: c.textMuted,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _logout,
                        icon: Icon(Icons.logout, color: c.danger, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const StoreIllustration(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Text(
                        l.createOrgTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: c.textPrimary,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.createOrgSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: c.textMuted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      KFormField(
                        label: l.createOrgBusinessName,
                        controller: _businessName,
                        icon: const Icon(Icons.business_outlined),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      KFormField(
                        label: l.createOrgBranchName,
                        controller: _branchName,
                        icon: const Icon(Icons.warehouse_outlined),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
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
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
                  child: Column(
                    children: [
                      KPrimaryBtn(
                        fullWidth: true,
                        icon: const Icon(Icons.arrow_outward),
                        onPressed: _submitting ? null : _submit,
                        child: Text(l.createOrgCta),
                      ),
                      const SizedBox(height: 14),
                      const KStepDots(count: 3, current: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
