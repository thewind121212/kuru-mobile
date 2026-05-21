import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Storefront with cascading boxes that bounce in on first mount.
/// Direct adaptation of the design's ScreenCreateOrg illustration.
class StoreIllustration extends StatefulWidget {
  const StoreIllustration({super.key});

  @override
  State<StoreIllustration> createState() => _StoreIllustrationState();
}

class _StoreIllustrationState extends State<StoreIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 240,
      height: 180,
      child: AnimatedBuilder(
        animation: _ctl,
        builder: (context, _) {
          return Stack(
            children: [
              // floor
              Positioned(
                bottom: 6,
                left: 20,
                right: 20,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              // storefront
              Positioned(
                bottom: 12,
                left: 65,
                child: Container(
                  width: 110,
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.surfaceElev,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: c.shadowMd,
                    border: Border.all(color: c.borderSoft),
                  ),
                  child: Column(
                    children: [
                      // sign
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color.alphaBlend(
                            c.primary.withValues(alpha: 0.25),
                            Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (final on in const [true, true, true, false])
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: on ? c.primarySoft : c.secondarySoft,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // awning (over storefront)
              Positioned(
                bottom: 102,
                left: 57,
                child: Container(
                  width: 126,
                  height: 18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [c.primary, c.secondary]),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),

              // 5 stacking boxes, each with a delayed bounce
              for (final cfg in const [
                _BoxCfg(x: 14, y: 100, delay: 0, hue: 280, small: false),
                _BoxCfg(x: 178, y: 90, delay: 0.10, hue: 220, small: false),
                _BoxCfg(x: 32, y: 60, delay: 0.20, hue: 340, small: true),
                _BoxCfg(x: 168, y: 40, delay: 0.30, hue: 30, small: true),
                _BoxCfg(x: 100, y: 10, delay: 0.40, hue: 200, small: true),
              ])
                _AnimatedBox(cfg: cfg, t: _ctl.value, c: c),
            ],
          );
        },
      ),
    );
  }
}

class _BoxCfg {
  const _BoxCfg({
    required this.x,
    required this.y,
    required this.delay,
    required this.hue,
    required this.small,
  });
  final double x;
  final double y;
  final double delay;
  final int hue;
  final bool small;
}

class _AnimatedBox extends StatelessWidget {
  const _AnimatedBox({required this.cfg, required this.t, required this.c});
  final _BoxCfg cfg;
  final double t;
  final KuruColors c;

  @override
  Widget build(BuildContext context) {
    final local = ((t - cfg.delay) / (1 - cfg.delay)).clamp(0.0, 1.0);
    final eased = Curves.easeOutBack.transform(local);
    final size = cfg.small ? 28.0 : 38.0;
    return Positioned(
      left: cfg.x,
      top: cfg.y - (1 - eased) * 30,
      child: Opacity(
        opacity: local,
        child: Transform.rotate(
          angle: (1 - eased) * 0.12,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HSLColor.fromAHSL(1, cfg.hue.toDouble(), 0.6, 0.6).toColor(),
                  HSLColor.fromAHSL(
                    1,
                    (cfg.hue + 30) % 360,
                    0.65,
                    0.5,
                  ).toColor(),
                ],
              ),
              boxShadow: c.shadowSm,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.inventory_2_outlined,
              size: cfg.small ? 16 : 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
