import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';

/// Placeholder body for /catalog/categories/:id. Plan 2 replaces this
/// with the real header card + children list. Routing contract is wired
/// here so Plan 2 only swaps the body, not the route.
class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({required this.categoryId, super.key});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: KEmptyState(
        icon: TablerIcons.tools,
        title: l.categoryDetailPlaceholder,
      ),
    );
  }
}
