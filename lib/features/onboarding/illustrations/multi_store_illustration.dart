import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 5 illustration — three small storefront cards connected by a dotted
/// network line, with a central "you" pill above them.
class MultiStoreIllustration extends StatelessWidget {
  const MultiStoreIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 360,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // soft backdrop
          Container(
            width: 280,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: RadialGradient(
                colors: [c.secondarySoft, Colors.transparent],
                radius: 0.8,
              ),
            ),
          ),

          // central account chip
          Positioned(
            top: 38,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: c.surfaceElev,
                borderRadius: BorderRadius.circular(99),
                boxShadow: c.shadowMd,
                border: Border.all(color: c.primary, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: c.primary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Icon(Icons.person, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tài khoản của bạn',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // dotted connector lines from chip to each store
          Positioned(
            top: 84,
            child: CustomPaint(
              size: const Size(280, 100),
              painter: _NetworkPainter(c.primary),
            ),
          ),

          // 3 store cards across the bottom
          Positioned(
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StoreCard(label: 'Quận 1', tone: c.primary, shadow: c.shadowSm),
                const SizedBox(width: 16),
                _StoreCard(label: 'Hà Nội', tone: c.secondary, shadow: c.shadowSm),
                const SizedBox(width: 16),
                _StoreCard(label: 'Đà Nẵng', tone: c.accent500, shadow: c.shadowSm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({
    required this.label,
    required this.tone,
    required this.shadow,
  });

  final String label;
  final Color tone;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      width: 78,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.borderSoft),
        boxShadow: shadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.alphaBlend(
                tone.withValues(alpha: 0.18),
                Colors.transparent,
              ),
            ),
            child: Icon(Icons.storefront, color: tone, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkPainter extends CustomPainter {
  _NetworkPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final mid = Offset(size.width / 2, 0);
    final left = Offset(40, size.height);
    final centre = Offset(size.width / 2, size.height);
    final right = Offset(size.width - 40, size.height);
    _dottedLine(canvas, paint, mid, left);
    _dottedLine(canvas, paint, mid, centre);
    _dottedLine(canvas, paint, mid, right);
  }

  void _dottedLine(Canvas canvas, Paint paint, Offset a, Offset b) {
    const dash = 4.0;
    const gap = 4.0;
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    final unit = Offset(dx / len, dy / len);
    var travelled = 0.0;
    while (travelled < len) {
      final start = a + unit * travelled;
      final end = a + unit * (travelled + dash).clamp(0, len);
      canvas.drawLine(start, end, paint);
      travelled += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_NetworkPainter old) => old.color != color;
}
