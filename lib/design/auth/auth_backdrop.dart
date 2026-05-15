import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Three drifting ambient gradient orbs. Direct port of `AuthBackdrop`
/// in design/kuru/project/kuru-screens-1.jsx.
class AuthBackdrop extends StatefulWidget {
  const AuthBackdrop({super.key});

  @override
  State<AuthBackdrop> createState() => _AuthBackdropState();
}

class _AuthBackdropState extends State<AuthBackdrop>
    with TickerProviderStateMixin {
  late final AnimationController _orbA;
  late final AnimationController _orbB;

  @override
  void initState() {
    super.initState();
    _orbA = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _orbB = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _orbA.dispose();
    _orbB.dispose();
    super.dispose();
  }

  Offset _orbAOffset(double t) {
    if (t < 0.33) {
      final p = t / 0.33;
      return Offset(40 * p, 60 * p);
    } else if (t < 0.66) {
      final p = (t - 0.33) / 0.33;
      return Offset(40 - 70 * p, 60 - 30 * p);
    } else {
      final p = (t - 0.66) / 0.34;
      return Offset(-30 + 30 * p, 30 - 30 * p);
    }
  }

  Offset _orbBOffset(double t) {
    if (t < 0.40) {
      final p = t / 0.40;
      return Offset(-50 * p, -40 * p);
    } else if (t < 0.75) {
      final p = (t - 0.40) / 0.35;
      return Offset(-50 + 70 * p, -40 - 20 * p);
    } else {
      final p = (t - 0.75) / 0.25;
      return Offset(20 - 20 * p, -60 + 60 * p);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _orbA,
              builder: (context, _) {
                final off = _orbAOffset(_orbA.value);
                return Positioned(
                  top: -90 + off.dy,
                  left: -60 + off.dx,
                  child: _Orb(color: c.primary, size: 280, opacity: 0.32),
                );
              },
            ),
            AnimatedBuilder(
              animation: _orbB,
              builder: (context, _) {
                final off = _orbBOffset(_orbB.value);
                return Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.40 + off.dy,
                  right: -80 + off.dx,
                  child: _Orb(color: c.secondary, size: 240, opacity: 0.30),
                );
              },
            ),
            AnimatedBuilder(
              animation: _orbA,
              builder: (context, _) {
                final off = _orbAOffset((_orbA.value + 0.28) % 1.0);
                return Positioned(
                  bottom: -100 + off.dy,
                  left: MediaQuery.sizeOf(context).width * 0.18 + off.dx,
                  child: _Orb(color: c.accent500, size: 220, opacity: 0.22),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size, required this.opacity});
  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              Colors.transparent,
            ],
            stops: const [0, 0.65],
          ),
        ),
      ),
    );
  }
}
