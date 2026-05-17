import 'package:flutter/material.dart';

/// Tiny circular spinner used inside buttons, modals, and inline loaders.
/// Color defaults to the inherited `DefaultTextStyle` color so it blends
/// with surrounding text (e.g. inside a primary button: white text + white
/// spinner; inside a list row: textPrimary).
class KSpinner extends StatelessWidget {
  const KSpinner({super.key, this.size = 16, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? DefaultTextStyle.of(context).style.color;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: resolved == null ? null : AlwaysStoppedAnimation(resolved),
      ),
    );
  }
}
