import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 2 illustration — stacked warehouse boxes with arrows showing in/out
/// flow. Static.
class InventoryIllustration extends StatelessWidget {
  const InventoryIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 360,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floor shadow
          Positioned(
            bottom: 40,
            child: Container(
              width: 240,
              height: 8,
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          // Box stack (center, 3 boxes)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final hue in const [200, 280, 30])
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  width: 96,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        HSLColor.fromAHSL(1, hue.toDouble(), 0.6, 0.55)
                            .toColor(),
                        HSLColor.fromAHSL(
                          1,
                          (hue + 30).toDouble() % 360,
                          0.65,
                          0.45,
                        ).toColor(),
                      ],
                    ),
                    boxShadow: c.shadowSm,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
            ],
          ),

          // "In" arrow (left, pointing right toward stack)
          Positioned(
            left: 40,
            top: 130,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: c.surfaceElev,
                    boxShadow: c.shadowSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward, size: 16, color: c.success),
                      const SizedBox(width: 4),
                      Text(
                        '+24',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: c.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // "Out" arrow (right, pointing away from stack)
          Positioned(
            right: 40,
            bottom: 130,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: c.surfaceElev,
                boxShadow: c.shadowSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '-3',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: c.warning,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: c.warning),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
