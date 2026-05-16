import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 1 illustration — a phone showing a barcode-scan viewfinder with a
/// floating "product detected" card and a success check. Static layout
/// (no animation in v1; the scan-beam keyframe lives in design/kuru-theme.js
/// and can be ported later).
class ScanIllustration extends StatelessWidget {
  const ScanIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 360,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft concentric pulse rings (static)
          for (var i = 0; i < 3; i++)
            Container(
              width: 240 + i * 20.0,
              height: 240 + i * 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: c.primary.withValues(alpha: 0.18 - i * 0.05),
                  width: 2,
                ),
              ),
            ),

          // Phone body (center)
          Container(
            width: 152,
            height: 220,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: c.textPrimary,
              boxShadow: c.shadowPop,
              border: Border.all(color: c.surfaceElev, width: 5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c.primary, c.secondary],
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 80,
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        18,
                        (i) => Expanded(
                          flex: ((i * 7 + 3) % 3) + 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0.5,
                            ),
                            child: Container(
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating product card (top-left)
          Positioned(
            top: 12,
            left: 20,
            child: Container(
              width: 124,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: c.surfaceElev,
                boxShadow: c.shadowMd,
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFE53935), Color(0xFFD84315)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'CC',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Coca-Cola',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: c.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '12.000₫',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: c.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Success badge (top-right)
          Positioned(
            top: 20,
            right: 16,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: c.success,
                boxShadow: [
                  BoxShadow(
                    color: c.success.withValues(alpha: 0.40),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.check, size: 26, color: Colors.white),
            ),
          ),

          // Cart pill (bottom-right)
          Positioned(
            bottom: 14,
            right: 28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: c.surfaceElev,
                boxShadow: c.shadowMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 22,
                    color: c.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '+1',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
