import 'package:flutter/widgets.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

// Re-export so callers can import this file alone and get the shared
// `KActionItem` model — same actions list works for both KPopupMenu and
// the bottom-sheet `KActionSheet`.
export 'package:kuru_mobile/design/core/modal/k_action_sheet.dart'
    show KActionItem;

/// **Temporarily stubbed for iOS 26 install debugging (2026-05-18).**
///
/// The real implementation uses `super_context_menu` (Rust binding) to
/// render native iOS UIContextMenu / Android popup. That Rust binary is
/// the prime suspect for the splash-then-crash on iOS 26 devices (the
/// build emitted warnings about it being built for iOS 17.5 but linked
/// at 14.0).
///
/// This stub returns the child unchanged — long-press does nothing.
/// Plan 1 doesn't use long-press menus anyway (only the debug-only
/// CoreDesignDemoScreen + Plan 2 will need them), so removing the
/// behaviour is acceptable while we verify the crash source.
///
/// When restoring: import `package:super_context_menu/super_context_menu.dart`
/// and replace this build() with the ContextMenuWidget version preserved
/// in git history.
class KPopupMenu<T> extends StatelessWidget {
  const KPopupMenu({
    required this.actions,
    required this.onSelected,
    required this.child,
    super.key,
  });

  final List<KActionItem<T>> actions;

  /// Fires with the picked action's id when a menu item is tapped.
  /// Currently unused — the stub doesn't render a menu.
  final ValueChanged<T> onSelected;

  /// The widget to wrap (typically a `KListRow` or `KCategoryCard`).
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
