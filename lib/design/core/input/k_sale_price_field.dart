// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/input/k_currency_field.dart';

/// Currency input with optional sale/reduction chips.
///
/// The saved value is still the final price. The chips are only a helper for
/// reducing from [referenceValue], so repositories keep sending `sellPrice`.
class KSalePriceField extends StatelessWidget {
  const KSalePriceField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.referenceValue,
    this.errorText,
    this.salePercents = const [5, 10, 20],
    super.key,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final int? referenceValue;
  final String? errorText;
  final List<int> salePercents;

  static final _vnFormatter = NumberFormat('#,###', 'vi_VN');

  static int priceAfterReduction(int basePrice, int percent) {
    return (basePrice * (100 - percent) / 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final reference = referenceValue;
    final canReduce = reference != null && reference > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        KCurrencyField(
          label: label,
          value: value,
          errorText: errorText,
          saleReferenceValue: reference,
          salePercents: canReduce ? salePercents : const <int>[],
          onChanged: onChanged,
        ),
        if (canReduce) ...[
          const SizedBox(height: 10),
          _ReductionSummary(referenceValue: reference, value: value),
        ],
      ],
    );
  }
}

class _ReductionSummary extends StatelessWidget {
  const _ReductionSummary({required this.referenceValue, required this.value});

  final int referenceValue;
  final int? value;

  @override
  Widget build(BuildContext context) {
    final current = value;
    if (current == null || current >= referenceValue) {
      return const SizedBox.shrink();
    }
    final c = kuruColors(context);
    final delta = referenceValue - current;
    final percent = delta / referenceValue * 100;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.dangerSoft.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.danger.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(TablerIcons.trending_down, size: 18, color: c.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Giá cũ ${_format(referenceValue)}đ → '
              '${_format(current)}đ',
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '-${_format(delta)}đ (${percent.toStringAsFixed(0)}%)',
            style: TextStyle(
              color: c.danger,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  static String _format(int value) =>
      KSalePriceField._vnFormatter.format(value);
}
