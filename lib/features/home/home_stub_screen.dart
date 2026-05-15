import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';

class HomeStubScreen extends ConsumerWidget {
  const HomeStubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final bootstrap = ref.watch(appBootstrapProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: bootstrap.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (state) => state is BootstrapAuthed
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 64, color: c.success),
                      const SizedBox(height: 16),
                      Text(
                        l.homeStubTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.homeStubBody(
                          state.user.email ?? '?',
                          state.user.orgInfos.isNotEmpty
                              ? state.user.orgInfos.first.name
                              : '(no org)',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: c.textSecondary),
                      ),
                      const SizedBox(height: 32),
                      KPrimaryBtn(
                        tone: KBtnTone.danger,
                        onPressed: () async {
                          final repo = ref.read(authRepositoryProvider);
                          await repo.signOut();
                          ref.read(currentOrgIdProvider.notifier).clear();
                          ref.invalidate(appBootstrapProvider);
                        },
                        child: Text(l.homeStubLogout),
                      ),
                    ],
                  )
                : const Center(child: Text('No session')),
          ),
        ),
      ),
    );
  }
}
