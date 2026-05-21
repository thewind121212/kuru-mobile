// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Single-line search input. Leading Tabler search icon, trailing clear
/// button (IconButton with tooltip='Clear', 48dp tap target) when text is
/// non-empty. Focused state shows a 4dp accent ring.
class KSearchBar extends StatefulWidget {
  const KSearchBar({
    required this.onChanged,
    super.key,
    this.hint,
    this.controller,
  });

  final String? hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  State<KSearchBar> createState() => _KSearchBarState();
}

class _KSearchBarState extends State<KSearchBar> {
  late final TextEditingController _ctl;
  final FocusNode _focus = FocusNode();
  bool _ownedCtl = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ctl = TextEditingController();
      _ownedCtl = true;
    } else {
      _ctl = widget.controller!;
    }
    _ctl.addListener(_onChanged);
    _focus.addListener(() => setState(() {}));
  }

  void _onChanged() {
    widget.onChanged(_ctl.text);
    setState(() {}); // toggle clear icon
  }

  @override
  void dispose() {
    _ctl.removeListener(_onChanged);
    if (_ownedCtl) _ctl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _clear() {
    _ctl.clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final focused = _focus.hasFocus;
    final hasText = _ctl.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: focused ? c.accent500 : c.border),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: c.accent500.withValues(alpha: 0.1),
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            TablerIcons.search,
            size: 18,
            color: focused ? c.accent500 : c.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctl,
              focusNode: _focus,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          // Always rendered so widget tests can find/tap it by tooltip
          // without needing a pump between enterText and tap. Visibility
          // is gated through opacity; tapping when empty is a harmless
          // no-op (clear of empty string).
          Opacity(
            opacity: hasText ? 1 : 0,
            child: IconButton(
              icon: Icon(TablerIcons.x, size: 18, color: c.textMuted),
              tooltip: 'Clear',
              iconSize: 18,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              padding: EdgeInsets.zero,
              splashRadius: 24,
              onPressed: _clear,
            ),
          ),
        ],
      ),
    );
  }
}
