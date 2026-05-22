import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/org_picker/org_card.dart';

class OrgPickerScreen extends ConsumerWidget {
  const OrgPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final currentOrgId = ref.watch(currentOrgIdProvider);

    return bootstrap.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (state) {
        if (state is! BootstrapAuthed) {
          return const Scaffold(body: Center(child: Text('No session')));
        }
        final orgs = state.user.orgInfos;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.orgPickerTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary,
                    letterSpacing: -0.55,
                  ),
                ),
                Text(
                  l.orgPickerSubtitle(orgs.length),
                  style: TextStyle(fontSize: 12, color: c.textMuted),
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
              children: [
                for (final org in orgs) ...[
                  OrgCard(
                    org: org,
                    active: org.id == currentOrgId,
                    onTap: () {
                      ref.read(orgIdOverrideProvider.notifier).orgId = org.id;
                      context.go('/home');
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => context.go('/create-org'),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: c.border, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 18, color: c.primary),
                        const SizedBox(width: 6),
                        Text(
                          l.orgPickerCreateNew,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shield_outlined, size: 20, color: c.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.orgPickerNote,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
