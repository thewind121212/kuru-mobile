// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Full-screen immersive barcode scanner.
///
/// Returns the first scanned value (or `null` if dismissed). No system app
/// bar — floating controls overlay on the live camera feed for an edge-to-
/// edge experience. Supported formats (mobile_scanner 7.x): EAN-8/13,
/// UPC-A/E, Code128/39, QR. The camera stops on first hit, so callers do
/// not need their own debouncer.
Future<String?> showKBarcodeScannerSheet(
  BuildContext context, {
  String title = 'Quét mã vạch',
  String hint = 'Hướng camera vào mã vạch để quét',
}) {
  return Navigator.of(context).push<String>(
    PageRouteBuilder<String>(
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (_, animation, __) => FadeTransition(
        opacity: animation,
        child: _BarcodeScannerSheet(title: title, hint: hint),
      ),
    ),
  );
}

class _BarcodeScannerSheet extends StatefulWidget {
  const _BarcodeScannerSheet({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  State<_BarcodeScannerSheet> createState() => _BarcodeScannerSheetState();
}

class _BarcodeScannerSheetState extends State<_BarcodeScannerSheet>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _controller;
  late final AnimationController _scanLineCtrl;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const [
        BarcodeFormat.ean8,
        BarcodeFormat.ean13,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.qrCode,
      ],
    );
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) return;
    final value = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
    if (value == null) return;
    _handled = true;
    await HapticFeedback.mediumImpact();
    await _controller.stop();
    if (!mounted) return;
    Navigator.of(context).pop<String>(value);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(controller: _controller, onDetect: _onDetect),
            _Viewfinder(scanLine: _scanLineCtrl),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopBar(
                title: widget.title,
                controller: _controller,
                onClose: () => Navigator.of(context).pop<String>(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomHint(hint: widget.hint),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.controller,
    required this.onClose,
  });

  final String title;
  final MobileScannerController controller;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
        top: topPad + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Color(0x00000000)],
        ),
      ),
      child: Row(
        children: [
          _FloatingIconButton(
            icon: TablerIcons.x,
            onTap: onClose,
            semanticLabel: 'Đóng',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, _) {
              final torchOn = state.torchState == TorchState.on;
              return _FloatingIconButton(
                icon: torchOn ? TablerIcons.bulb_filled : TablerIcons.bulb,
                active: torchOn,
                onTap: controller.toggleTorch,
                semanticLabel: torchOn ? 'Tắt đèn pin' : 'Bật đèn pin',
              );
            },
          ),
          const SizedBox(width: 8),
          _FloatingIconButton(
            icon: TablerIcons.camera_rotate,
            onTap: controller.switchCamera,
            semanticLabel: 'Đổi camera',
          ),
        ],
      ),
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  const _FloatingIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final bg = active ? Colors.white : Colors.black.withValues(alpha: 0.45);
    final fg = active ? Colors.black : Colors.white;
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: fg),
          ),
        ),
      ),
    );
  }
}

class _BottomHint extends StatelessWidget {
  const _BottomHint({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 28,
        bottom: bottomPad + 32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0xCC000000)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Icon(TablerIcons.barcode, color: c.accent300, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Viewfinder extends StatelessWidget {
  const _Viewfinder({required this.scanLine});

  final AnimationController scanLine;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final boxW = w * 0.78;
        final boxH = boxW;
        final left = (w - boxW) / 2;
        final top = (h - boxH) / 2 - 16;
        return Stack(
          children: [
            IgnorePointer(
              child: CustomPaint(
                size: Size(w, h),
                painter: _ScrimPainter(
                  rect: Rect.fromLTWH(left, top, boxW, boxH),
                  radius: 24,
                ),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: boxW,
              height: boxH,
              child: IgnorePointer(
                child: Stack(
                  children: [
                    _CornerBrackets(color: c.accent300),
                    AnimatedBuilder(
                      animation: scanLine,
                      builder: (context, _) {
                        return Positioned(
                          left: 12,
                          right: 12,
                          top: 12 + (boxH - 24) * scanLine.value,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  c.accent300.withValues(alpha: 0),
                                  c.accent300,
                                  c.accent300.withValues(alpha: 0),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: c.accent300.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScrimPainter extends CustomPainter {
  _ScrimPainter({required this.rect, required this.radius});

  final Rect rect;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Paint()..color = Colors.black.withValues(alpha: 0.62);
    final outer = Path()..addRect(Offset.zero & size);
    final hole = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    final combined = Path.combine(PathOperation.difference, outer, hole);
    canvas.drawPath(combined, scrim);
  }

  @override
  bool shouldRepaint(covariant _ScrimPainter oldDelegate) {
    return oldDelegate.rect != rect || oldDelegate.radius != radius;
  }
}

class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _CornerBracketsPainter(color: color),
    );
  }
}

class _CornerBracketsPainter extends CustomPainter {
  _CornerBracketsPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const arm = 28.0;
    const stroke = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas
      // Top-left.
      ..drawLine(const Offset(0, arm), Offset.zero, paint)
      ..drawLine(Offset.zero, const Offset(arm, 0), paint)
      // Top-right.
      ..drawLine(Offset(size.width - arm, 0), Offset(size.width, 0), paint)
      ..drawLine(Offset(size.width, 0), Offset(size.width, arm), paint)
      // Bottom-left.
      ..drawLine(Offset(0, size.height - arm), Offset(0, size.height), paint)
      ..drawLine(Offset(0, size.height), Offset(arm, size.height), paint)
      // Bottom-right.
      ..drawLine(
        Offset(size.width - arm, size.height),
        Offset(size.width, size.height),
        paint,
      )
      ..drawLine(
        Offset(size.width, size.height - arm),
        Offset(size.width, size.height),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _CornerBracketsPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
