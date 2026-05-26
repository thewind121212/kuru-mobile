// flutter_tabler_icons uses snake_case symbols (e.g. TablerIcons.layout_grid)
// which trigger non_constant_identifier_names when used as const values.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/main_shell/kuru_bottom_nav.dart';

/// Presentation-only shell with the custom [KuruBottomNav]. Routing-owned —
/// the parent (router's StatefulShellRoute builder) supplies currentIndex
/// + onTabChanged + the active tab body.
///
/// The raised center action on the bottom nav is the global Point-of-Sale
/// entry (visible on every tab).
class MainShell extends StatelessWidget {
  const MainShell({
    required this.currentIndex,
    required this.onTabChanged,
    required this.body,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Widget body;

  void _onPosPressed(BuildContext context) {
    context.push('/pos');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      // Body extends behind the floating glass pill — required for
      // KuruBottomNav's BackdropFilter to have anything to sample.
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(child: body),
          _CenterActionHitTarget(
            label: l.posOpenTooltip,
            onTap: () => _onPosPressed(context),
          ),
        ],
      ),
      bottomNavigationBar: KuruBottomNav(
        currentIndex: currentIndex,
        onTabChanged: onTabChanged,
        tabs: [
          KuruBottomNavItem(icon: TablerIcons.home, label: l.navHome),
          KuruBottomNavItem(icon: TablerIcons.layout_grid, label: l.navCatalog),
          KuruBottomNavItem(icon: TablerIcons.report_money, label: l.navLedger),
          KuruBottomNavItem(icon: TablerIcons.settings, label: l.navSettings),
        ],
        actionIcon: TablerIcons.building_store,
        actionTooltip: l.posOpenTooltip,
        onActionPressed: () => _onPosPressed(context),
      ),
    );
  }
}

class _CenterActionHitTarget extends StatelessWidget {
  const _CenterActionHitTarget({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 48,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Semantics(
          label: label,
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: const SizedBox(width: 64, height: 64),
          ),
        ),
      ),
    );
  }
}
