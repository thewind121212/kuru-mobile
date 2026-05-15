import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

enum KBtnTone { primary, success, danger }

class KPrimaryBtn extends StatefulWidget {
  const KPrimaryBtn({
    required this.child,
    super.key,
    this.icon,
    this.onPressed,
    this.fullWidth = false,
    this.tone = KBtnTone.primary,
    this.shine = true,
  });

  final Widget child;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final KBtnTone tone;
  final bool shine;

  @override
  State<KPrimaryBtn> createState() => _KPrimaryBtnState();
}

class _KPrimaryBtnState extends State<KPrimaryBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    if (widget.shine && widget.onPressed != null) _ctl.repeat();
  }

  @override
  void didUpdateWidget(KPrimaryBtn old) {
    super.didUpdateWidget(old);
    final shouldShine = widget.shine && widget.onPressed != null;
    if (shouldShine && !_ctl.isAnimating) {
      _ctl.repeat();
    } else if (!shouldShine && _ctl.isAnimating) {
      _ctl.stop();
    }
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Color _bg(KuruColors c) => switch (widget.tone) {
        KBtnTone.primary => c.primary,
        KBtnTone.success => c.success,
        KBtnTone.danger => c.danger,
      };

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final btn = Material(
      color: _bg(c),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: c.textInverse, size: 18),
                  child: widget.icon!,
                ),
                const SizedBox(width: 8),
              ],
              DefaultTextStyle.merge(
                style: TextStyle(
                  color: c.textInverse,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: -0.14,
                ),
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );

    final sized = widget.fullWidth
        ? SizedBox(width: double.infinity, child: btn)
        : btn;

    if (!widget.shine) return sized;
    return Stack(
      children: [
        sized,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AnimatedBuilder(
                animation: _ctl,
                builder: (context, _) {
                  final pos = -1.2 + _ctl.value * 3.4;
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment(pos - 0.4, 0),
                      end: Alignment(pos + 0.4, 0),
                      colors: const [
                        Colors.transparent,
                        Color(0x59FFFFFF),
                        Colors.transparent,
                      ],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcATop,
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
