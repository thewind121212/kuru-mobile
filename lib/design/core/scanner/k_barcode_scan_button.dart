// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/scanner/k_barcode_scanner_sheet.dart';

/// Compact trigger that opens the full-screen barcode scanner and passes
/// the scanned value to [onScan]. Designed to drop into the `trailingIcon`
/// slot of `KTextField` (or anywhere else a 32×32 tappable affordance fits).
class KBarcodeScanButton extends StatelessWidget {
  const KBarcodeScanButton({
    required this.onScan,
    super.key,
    this.tooltip = 'Quét mã vạch',
    this.title = 'Quét mã vạch',
    this.hint = 'Hướng camera vào mã vạch để quét',
  });

  final ValueChanged<String> onScan;
  final String tooltip;
  final String title;
  final String hint;

  Future<void> _open(BuildContext context) async {
    final value = await showKBarcodeScannerSheet(
      context,
      title: title,
      hint: hint,
    );
    if (value != null && value.isNotEmpty) onScan(value);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Semantics(
      label: tooltip,
      button: true,
      child: Tooltip(
        message: tooltip,
        child: InkResponse(
          radius: 22,
          onTap: () => _open(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(TablerIcons.scan, size: 20, color: c.accent600),
          ),
        ),
      ),
    );
  }
}
