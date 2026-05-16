import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 6 illustration — a customer avatar surrounded by floating metric chips
/// (purchases, points, last visit).
class CustomerIllustration extends StatelessWidget {
  const CustomerIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 360,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ambient ring
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c.primarySoft, width: 18),
            ),
          ),

          // central avatar
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c.primary, c.secondary],
              ),
              boxShadow: c.shadowPop,
            ),
            alignment: Alignment.center,
            child: const Text(
              'NA',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 34,
                letterSpacing: -1,
              ),
            ),
          ),

          // VIP star pill (top-left)
          Positioned(
            top: 30,
            left: 50,
            child: const _MetricChip(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFFACC15),
              label: 'VIP',
              value: '4.8',
            ),
          ),

          // Purchases pill (top-right)
          Positioned(
            top: 20,
            right: 36,
            child: _MetricChip(
              icon: Icons.shopping_bag_outlined,
              iconColor: c.success,
              label: 'Đơn',
              value: '127',
            ),
          ),

          // Last visit (bottom-left)
          Positioned(
            bottom: 50,
            left: 38,
            child: _MetricChip(
              icon: Icons.access_time,
              iconColor: c.secondary,
              label: 'Lần cuối',
              value: '2 ngày',
            ),
          ),

          // Loyalty points (bottom-right)
          Positioned(
            bottom: 36,
            right: 50,
            child: _MetricChip(
              icon: Icons.workspace_premium_outlined,
              iconColor: c.primary,
              label: 'Điểm',
              value: '1.2k',
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.borderSoft),
        boxShadow: c.shadowSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: c.textMuted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
