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

/// Recursive indented tree showing every root category + descendants.
///
/// Mirrors kuru-web's `NestedCategoriesView` / `CategoryTreeItem` pattern:
/// each node is a card with a layer badge, name, and action menu. Non-leaf
/// nodes have a chevron (rotates 90° when expanded). When [focusedId] is
/// provided, the matching node gets an accent halo + ring, and every
/// ancestor on the path from a root down to that node is auto-expanded so
/// the focused row is visible without scrolling.
///
/// Children are derived client-side from [allCategories] by filtering on
/// `parentId`. The whole tree builds from one network round-trip
/// (the overview provider).
class CategoryTree extends StatelessWidget {
  const CategoryTree({
    required this.allCategories,
    this.rootId,
    this.focusedId,
    super.key,
  });

  final List<gen.CategoryResponse> allCategories;

  /// When set, the tree renders ONLY the node matching this id as its lone
  /// root (regardless of that node's `parentId`). Use on detail screens to
  /// scope the view to one category's subtree.
  final String? rootId;

  /// Optional id of the category to highlight (and auto-expand the path
  /// to). When null, the tree renders unfocused with default expansion
  /// (root + first-level children expanded; deeper levels collapsed).
  final String? focusedId;

  static const _nilUuid = '00000000-0000-0000-0000-000000000000';

  /// Roots to render. When [rootId] is set, the single matching node;
  /// otherwise every category whose `parentId` is null or NIL_UUID.
  List<gen.CategoryResponse> get _roots {
    if (rootId != null) {
      return allCategories.where((c) => c.categoryId == rootId).toList();
    }
    return allCategories.where((c) {
      final p = c.parentId;
      return p == null || p == _nilUuid;
    }).toList();
  }

  /// Set of ids on the path from the focused node up to (and including)
  /// its root. Used by [_TreeNode] to auto-expand the ancestor chain.
  Set<String> _ancestorIds() {
    if (focusedId == null) return const {};
    final byId = <String, gen.CategoryResponse>{};
    for (final c in allCategories) {
      final id = c.categoryId;
      if (id != null) byId[id] = c;
    }
    final ancestors = <String>{};
    var cur = focusedId;
    while (cur != null && ancestors.add(cur)) {
      final parent = byId[cur]?.parentId;
      cur = (parent == null || parent == _nilUuid) ? null : parent;
    }
    return ancestors;
  }

  @override
  Widget build(BuildContext context) {
    final roots = _roots;
    if (roots.isEmpty) return const SizedBox.shrink();
    final ancestors = _ancestorIds();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final root in roots) ...[
          _TreeNode(
            node: root,
            allCategories: allCategories,
            level: 0,
            focusedId: focusedId,
            ancestorIds: ancestors,
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
    required this.ancestorIds,
    this.focusedId,
  });

  final gen.CategoryResponse node;
  final List<gen.CategoryResponse> allCategories;
  final int level;

  /// Id of the focused node, or null if no focus. Used to highlight one
  /// row in the tree.
  final String? focusedId;

  /// Set of node ids on the path from a root down to [focusedId]
  /// (inclusive). Nodes in this set auto-expand on initial build so the
  /// focused row is visible.
  final Set<String> ancestorIds;

  bool get isFocused => focusedId != null && node.categoryId == focusedId;

  bool get isOnFocusedPath =>
      node.categoryId != null && ancestorIds.contains(node.categoryId);

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
    // Auto-expand if (a) the node is on the focused path (so the focused
    // row is visible without tapping), or (b) no focus is set and this
    // is a top-level root (give the user a default sense of structure).
    _expanded =
        widget.isOnFocusedPath ||
        (widget.focusedId == null && widget.level == 0);
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

    // Row itself is NOT tappable. Only the chevron (its own InkWell) and
    // the kebab toggle behavior — row tap does nothing, per UX.
    final card = Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: EdgeInsets.only(left: widget.level * _indentPerLevel),
        decoration: BoxDecoration(
          border: Border.all(color: cardBorder),
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              // Chevron is the ONLY tap target for expand/collapse. Wrapped
              // in its own InkWell so only its hit area toggles.
              if (hasChildren)
                InkWell(
                  onTap: _toggle,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
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
                  ),
                )
              else
                const SizedBox(width: 26),
              const SizedBox(width: 4),
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
              Expanded(
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
              // Kebab — its own InkWell blocks the row tap so we don't
              // toggle expand when the user actually wanted the menu.
              KIconBtn(
                icon: const Icon(TablerIcons.dots_vertical),
                size: 32,
                onPressed: _onMenu,
              ),
            ],
          ),
        ),
      ),
    );

    // Children always rendered (no destroy/recreate on toggle — keeps
    // their _TreeNodeState alive). ClipRect + AnimatedAlign animates the
    // visible height between 0 and full — smoother than the prior
    // AnimatedSize-with-ternary which flashed because the child widget
    // tree itself was being replaced.
    final childrenColumn = hasChildren
        ? ClipRect(
            child: AnimatedAlign(
              alignment: Alignment.topCenter,
              heightFactor: _expanded ? 1.0 : 0.0,
              duration: _animDuration,
              curve: Curves.easeOut,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final child in children) ...[
                      _TreeNode(
                        node: child,
                        allCategories: widget.allCategories,
                        level: widget.level + 1,
                        focusedId: widget.focusedId,
                        ancestorIds: widget.ancestorIds,
                      ),
                      const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [card, childrenColumn],
    );
  }
}
