// flutter_tabler_icons uses snake_case symbols (e.g. TablerIcons.layout_grid)
// which trigger non_constant_identifier_names when used as const values.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

/// Presentation-only shell with a bottom NavigationBar. Routing-owned —
/// the parent (router's StatefulShellRoute builder) supplies currentIndex
/// + onTabChanged + the active tab body.
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: body,
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
