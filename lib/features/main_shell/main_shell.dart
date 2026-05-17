// flutter_tabler_icons uses snake_case symbols (e.g. TablerIcons.layout_grid)
// which trigger non_constant_identifier_names when used as const values.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

/// Presentation-only shell with a bottom NavigationBar plus a POS FAB.
/// Routing-owned — the parent (router's StatefulShellRoute builder) supplies
/// currentIndex + onTabChanged + the active tab body.
///
/// The trailing FAB is a global Point-of-Sale entry point (visible on every
/// tab). Plan 1 has no POS screen yet; tapping shows a placeholder snackbar.
/// Replace [_onPosPressed] with a `context.push('/pos')` when the POS feature
/// lands.
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
    final c = kuruColors(context);
    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onPosPressed(context),
        backgroundColor: c.accent600,
        foregroundColor: Colors.white,
        elevation: 4,
        tooltip: l.posOpenTooltip,
        child: const Icon(TablerIcons.plus, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTabChanged,
        destinations: [
          NavigationDestination(
            icon: const Icon(TablerIcons.home),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(TablerIcons.layout_grid),
            label: l.navCatalog,
          ),
          NavigationDestination(
            icon: const Icon(TablerIcons.settings),
            label: l.navSettings,
          ),
        ],
      ),
    );
  }
}
