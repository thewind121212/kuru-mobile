import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class AuthLogo extends StatefulWidget {
  const AuthLogo({super.key, this.small = false});
  final bool small;

  @override
  State<AuthLogo> createState() => _AuthLogoState();
}

class _AuthLogoState extends State<AuthLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final size = widget.small ? 56.0 : 68.0;
    final radius = widget.small ? 16.0 : 20.0;
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, _) {
        final t = _glow.value;
        return SizedBox(
          width: size + 28,
          height: size + 28,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [
                    BoxShadow(
                      color: c.ambient1,
                      blurRadius: 24 + 8 * t,
                      offset: Offset(0, 8 + 6 * t),
                    ),
                    if (t < 0.5)
                      BoxShadow(
                        color: c.ambient2.withValues(alpha: 1 - t * 2),
                        spreadRadius: 14 * t,
                        blurRadius: 1,
                      ),
                  ],
                  border: Border.all(
                    color: c.textPrimary.withValues(alpha: 0.14),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/logo.webp', fit: BoxFit.cover),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: c.accent500.withValues(alpha: 0.6 + 0.4 * t),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Icon(
                  Icons.auto_awesome,
                  size: 10,
                  color: c.secondary.withValues(alpha: 0.4 + 0.6 * (1 - t)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
