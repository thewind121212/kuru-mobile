import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 3 illustration — a rising bar chart with a trend pill. Static.
class ChartIllustration extends StatelessWidget {
  const ChartIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    // bar heights as fractions of the chart area (rising trend)
    const heights = <double>[0.32, 0.45, 0.40, 0.62, 0.75, 0.88];
    return SizedBox(
      width: 360,
      height: 320,
      child: Center(
        child: Container(
          width: 280,
          height: 220,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          decoration: BoxDecoration(
            color: c.surfaceElev,
            borderRadius: BorderRadius.circular(20),
            boxShadow: c.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doanh thu tuần',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.textMuted,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: c.successSoft,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, size: 12, color: c.success),
                        const SizedBox(width: 3),
                        Text(
                          '+24%',
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
              const SizedBox(height: 14),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final h in heights) ...[
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: h,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [c.primary, c.secondary],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
