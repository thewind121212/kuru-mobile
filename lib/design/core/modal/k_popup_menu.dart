import 'package:flutter/widgets.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';
import 'package:super_context_menu/super_context_menu.dart';

// Re-export so callers can import this file alone and get the shared
// `KActionItem` model — same actions list works for both KPopupMenu and
// the bottom-sheet `KActionSheet`.
export 'package:kuru_mobile/design/core/modal/k_action_sheet.dart'
    show KActionItem;

/// Native iOS UIContextMenu / Android Material popup menu — long-press
/// the wrapped [child] to open. Use this for catalog rows and cards where
/// a discoverable popup feels more native than a bottom sheet; reach for
/// [showKActionSheet] when the trigger is an explicit "more" button.
///
/// Reuses [KActionItem] so the same action list serves both surfaces —
/// pick per use case without re-declaring actions.
class KPopupMenu<T> extends StatelessWidget {
  const KPopupMenu({
    required this.actions,
    required this.onSelected,
    required this.child,
    super.key,
  });

  final List<KActionItem<T>> actions;

  /// Fires with the picked action's id when a menu item is tapped.
  final ValueChanged<T> onSelected;

  /// The widget to wrap (typically a `KListRow` or `KCategoryCard`).
  /// Long-press it to pop the menu.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ContextMenuWidget(
      menuProvider: (_) => Menu(
        children: [
          for (final action in actions)
            MenuAction(
              title: action.label,
              image: action.icon != null ? MenuImage.icon(action.icon!) : null,
              attributes: MenuActionAttributes(
                disabled: !action.enabled,
                destructive: action.danger,
              ),
              callback: () => onSelected(action.id),
            ),
        ],
      ),
      child: child,
    );
  }
}
