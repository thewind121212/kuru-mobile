// TablerIcons uses snake_case names.
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/category_action_menu.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';

/// Recursive indented tree of categories rooted at [rootId].
///
/// Mirrors kuru-web's `NestedCategoriesView` / `CategoryTreeItem` pattern:
/// each node is a card with a layer badge, name, and action menu. Non-leaf
/// nodes have a chevron (rotates 90° when expanded). The root node is
/// always rendered "focused" — accent border + accent-tinted background +
/// ring — to anchor the viewer on which category they drilled into.
///
/// Children are derived client-side from [allCategories] by filtering on
/// `parentId`. The whole tree builds from one network round-trip
/// (the overview provider).
class CategoryTree extends StatelessWidget {
  const CategoryTree({
    required this.rootId,
    required this.allCategories,
    this.includeRoot = true,
    super.key,
  });

  final String rootId;
  final List<gen.CategoryResponse> allCategories;

  /// When true, render the root node itself as the first (focused) card,
  /// then descendants below. When false (the detail-screen case where
  /// the parent screen owns the header card), render only the direct
  /// children of [rootId] at level 0 with no enclosing root.
  final bool includeRoot;

  gen.CategoryResponse? get _root {
    for (final c in allCategories) {
      if (c.categoryId == rootId) return c;
    }
    return null;
  }

  List<gen.CategoryResponse> get _directChildren =>
      allCategories.where((c) => c.parentId == rootId).toList();

  @override
  Widget build(BuildContext context) {
    if (includeRoot) {
      final root = _root;
      if (root == null) return const SizedBox.shrink();
      return _TreeNode(
        node: root,
        allCategories: allCategories,
        level: 0,
        isFocused: true,
      );
    }
    final children = _directChildren;
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final child in children) ...[
          _TreeNode(
            node: child,
            allCategories: allCategories,
            level: 0,
            isFocused: false,
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _TreeNode extends ConsumerStatefulWidget {
  const _TreeNode({
    required this.node,
    required this.allCategories,
    required this.level,
    required this.isFocused,
  });

  final gen.CategoryResponse node;
  final List<gen.CategoryResponse> allCategories;
  final int level;
  final bool isFocused;

  @override
  ConsumerState<_TreeNode> createState() => _TreeNodeState();
}

class _TreeNodeState extends ConsumerState<_TreeNode>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _chevronController;

  static const _indentPerLevel = 20.0;
  static const _animDuration = Duration(milliseconds: 200);

  List<gen.CategoryResponse> get _children => widget.allCategories
      .where((c) => c.parentId == widget.node.categoryId)
      .toList();

  @override
  void initState() {
    super.initState();
    // Root level + first-level children are expanded by default so the
    // viewer sees the immediate sub-tree without tapping. Deeper levels
    // start collapsed to keep the surface visible without scrolling.
    _expanded = widget.level <= 1;
    _chevronController = AnimationController(
      vsync: this,
      duration: _animDuration,
      value: _expanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _chevronController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_children.isEmpty) return;
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _chevronController.forward();
    } else {
      _chevronController.reverse();
    }
  }

  Color _bg(KuruColors c) {
    final id = widget.node.colorSettings;
    if (id == null || id.isEmpty) return kAllColors.first.swatch;
    for (final co in kAllColors) {
      if (co.id == id) return co.swatch;
    }
    return kAllColors.first.swatch;
  }

  Future<void> _onMenu() async {
    final l = AppLocalizations.of(context);
    final canAdd = (int.tryParse(widget.node.layer ?? '1') ?? 1) < 5;
    final action = await showCategoryActionMenu(
      context: context,
      category: widget.node,
      canAddSubcategory: canAdd,
    );
    if (action == null || !mounted) return;
    switch (action) {
      case CategoryAction.edit:
        final saved = await showCreateEditCategorySheet(
          context: context,
          mode: EditCategory(category: widget.node),
        );
        if (!mounted) return;
        if (saved ?? false) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.categoryNotifySaved)));
        }
      case CategoryAction.addSubcategory:
        final saved = await showCreateEditCategorySheet(
          context: context,
          mode: CreateNested(
            parentId: widget.node.categoryId!,
            parentName: widget.node.name ?? '',
            parentLayer: widget.node.layer ?? '1',
          ),
        );
        if (!mounted) return;
        if (saved ?? false) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.categoryNotifySaved)));
          // Auto-expand so the newly-created child is visible.
          if (!_expanded) {
            setState(() => _expanded = true);
            unawaited(_chevronController.forward());
          }
        }
      case CategoryAction.delete:
        await _confirmAndDelete();
    }
  }

  Future<void> _confirmAndDelete() async {
    final l = AppLocalizations.of(context);
    ApiException? failure;
    final confirmed = await showKConfirmDialog(
      context: context,
      title: l.categoryDeleteConfirmTitle,
      subtitle: l.categoryDeleteConfirmBody(widget.node.name ?? ''),
      confirmLabel: l.categoryDeleteConfirmCta,
      onConfirm: () async {
        final result = await ref.read(categoryRepositoryProvider).remove([
          widget.node.categoryId!,
        ]);
        if (result is ApiFailure<void>) {
          failure = result.err;
          throw result.err;
        }
      },
    );
    if (!mounted) return;
    if (confirmed ?? false) {
      ref
        ..invalidate(categoryOverviewProvider)
        ..invalidate(categoryByIdProvider(widget.node.categoryId!));
      const nilUuid = '00000000-0000-0000-0000-000000000000';
      final parentId = widget.node.parentId;
      if (parentId != null && parentId != nilUuid) {
        ref.invalidate(categoryByIdProvider(parentId));
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.categoryNotifyDeleted)));
    } else if (failure != null) {
      final msg = failure is BadRequestException
          ? (failure! as BadRequestException).message
          : l.categoryNotifyServer;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final children = _children;
    final hasChildren = children.isNotEmpty;
    final isFocused = widget.isFocused;

    // Focused (the entered category) gets an accent halo + ring. Other
    // nodes are neutral.
    final cardBg = isFocused ? c.accent50 : c.surfaceElev;
    final cardBorder = isFocused ? c.accent400 : c.border;
    final boxShadow = isFocused
        ? [
            BoxShadow(
              color: c.accent100.withValues(alpha: 0.6),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ]
        : <BoxShadow>[];

    final card = Container(
      margin: EdgeInsets.only(left: widget.level * _indentPerLevel),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: cardBorder),
        borderRadius: BorderRadius.circular(10),
        boxShadow: boxShadow,
      ),
      child: Row(
        children: [
          // Chevron (or placeholder spacer for leaf nodes).
          if (hasChildren)
            GestureDetector(
              onTap: _toggle,
              child: RotationTransition(
                turns: Tween<double>(
                  begin: 0,
                  end: 0.25,
                ).animate(_chevronController),
                child: Icon(
                  TablerIcons.chevron_right,
                  size: 18,
                  color: c.textMuted,
                ),
              ),
            )
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          // Layer badge — small colored chip with the layer number.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _bg(c),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.node.layer ?? '?',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Name — tap toggles expand if has children.
          Expanded(
            child: GestureDetector(
              onTap: hasChildren ? _toggle : null,
              behavior: HitTestBehavior.opaque,
              child: Text(
                widget.node.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isFocused ? FontWeight.w700 : FontWeight.w500,
                  color: isFocused ? c.accent700 : c.textPrimary,
                ),
              ),
            ),
          ),
          // Kebab.
          KIconBtn(
            icon: const Icon(TablerIcons.dots_vertical),
            size: 32,
            onPressed: _onMenu,
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        card,
        if (hasChildren)
          AnimatedSize(
            duration: _animDuration,
            curve: Curves.easeOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final child in children) ...[
                          _TreeNode(
                            node: child,
                            allCategories: widget.allCategories,
                            level: widget.level + 1,
                            isFocused: false,
                          ),
                          const SizedBox(height: 6),
                        ],
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }
}
