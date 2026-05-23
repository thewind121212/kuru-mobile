// flutter_tabler_icons uses snake_case symbols (e.g. TablerIcons.layout_grid)
// which trigger non_constant_identifier_names when used as const values.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/main_shell/kuru_bottom_nav.dart';

/// Presentation-only shell with the custom [KuruBottomNav]. Routing-owned —
/// the parent (router's StatefulShellRoute builder) supplies currentIndex
/// + onTabChanged + the active tab body.
///
/// The trailing `+` action on the bottom nav is the global Point-of-Sale
/// entry (visible on every tab). Plan 1 has no POS screen yet; tapping
/// shows a placeholder snackbar. Replace [_onPosPressed] with a
/// `context.push('/pos')` when the POS feature lands.
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
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.posComingSoon),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      // Body extends behind the floating glass pill — required for
      // KuruBottomNav's BackdropFilter to have anything to sample.
      extendBody: true,
      body: body,
      bottomNavigationBar: KuruBottomNav(
        currentIndex: currentIndex,
        onTabChanged: onTabChanged,
        tabs: [
          KuruBottomNavItem(icon: TablerIcons.home, label: l.navHome),
          KuruBottomNavItem(icon: TablerIcons.layout_grid, label: l.navCatalog),
          KuruBottomNavItem(icon: TablerIcons.receipt, label: l.navOrders),
          KuruBottomNavItem(icon: TablerIcons.settings, label: l.navSettings),
        ],
        actionIcon: TablerIcons.plus,
        actionTooltip: l.posOpenTooltip,
        onActionPressed: () => _onPosPressed(context),
      ),
    );
  }
}
