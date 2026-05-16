import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 4 illustration — three payment-method tiles (cash, transfer, QR)
/// in a fanned overlap with a "received" check at the centre.
class PaymentIllustration extends StatelessWidget {
  const PaymentIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 360,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // soft ambient orb
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [c.primarySoft, Colors.transparent],
                stops: const [0, 0.7],
              ),
            ),
          ),

          // cash tile (left, tilted -10°)
          Positioned(
            left: 50,
            top: 100,
            child: Transform.rotate(
              angle: -0.18,
              child: _PaymentTile(
                icon: Icons.payments_outlined,
                label: 'Tiền mặt',
                gradient: const [Color(0xFF22C55E), Color(0xFF0D9488)],
                shadow: c.shadowMd,
              ),
            ),
          ),

          // transfer tile (centre, slight tilt)
          Positioned(
            top: 80,
            child: Transform.rotate(
              angle: 0.02,
              child: _PaymentTile(
                icon: Icons.compare_arrows,
                label: 'Chuyển khoản',
                gradient: [c.primary, c.secondary],
                shadow: c.shadowPop,
              ),
            ),
          ),

          // QR tile (right, tilted +10°)
          Positioned(
            right: 50,
            top: 100,
            child: Transform.rotate(
              angle: 0.18,
              child: _PaymentTile(
                icon: Icons.qr_code_2,
                label: 'QR',
                gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
                shadow: c.shadowMd,
              ),
            ),
          ),

          // success badge bottom-centre
          Positioned(
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: c.surfaceElev,
                borderRadius: BorderRadius.circular(14),
                boxShadow: c.shadowMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: c.success,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Đã ghi nhận',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.shadow,
  });

  final IconData icon;
  final String label;
  final List<Color> gradient;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 124,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: shadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
