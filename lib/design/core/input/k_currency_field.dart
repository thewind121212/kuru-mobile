// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Form-row trigger for money input. Tap to open a bottom sheet with a
/// hero number display, three quick-fill chips (×10/×100/×1000), and a
/// custom number pad. Mirrors `KFormField`'s visual shape (label above,
/// value inside, trailing chevron-down) and supports an animated error
/// slot for inline validation.
///
/// `value` is the int value in đồng (Vietnamese đ). `null` means "empty"
/// and renders a placeholder. The bottom sheet returns the new int (or
/// `null` if the user cancelled). The trigger then invokes [onChanged]
/// only if the returned value differs from the current [value].
class KCurrencyField extends StatelessWidget {
  const KCurrencyField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.saleReferenceValue,
    this.salePercents = const <int>[],
    this.reductionReferenceValue,
    this.reductionPercents = const <int>[],
    this.suffix = 'đ',
    this.allowZero = false,
    this.shrinkWrapSheet = false,
    this.previewBaseValue,
    this.previewZeroText,
    this.hideChevron = false,
    this.hideMultipliers = false,
    this.showPreviewInSheet = true,
    this.resetText,
    this.onReset,
    super.key,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final String? errorText;
  final int? saleReferenceValue;
  final List<int> salePercents;
  final int? reductionReferenceValue;
  final List<int> reductionPercents;
  final String suffix;
  final bool allowZero;
  final bool shrinkWrapSheet;
  final int? previewBaseValue;
  final String? previewZeroText;
  final bool hideChevron;
  final bool hideMultipliers;
  final bool showPreviewInSheet;
  final String? resetText;
  final VoidCallback? onReset;

  static final _vnFormatter = NumberFormat('#,###', 'vi_VN');

  Future<void> _open(BuildContext context) async {
    final c = kuruColors(context);
    final picked = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surfaceElev,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _CurrencySheetBody(
        label: label,
        suffix: suffix,
        initialValue: value ?? 0,
        saleReferenceValue: saleReferenceValue,
        salePercents: salePercents,
        reductionReferenceValue: reductionReferenceValue,
        reductionPercents: reductionPercents,
        allowZero: allowZero,
        shrinkWrap: shrinkWrapSheet,
        previewBaseValue: previewBaseValue,
        previewZeroText: previewZeroText,
        hideMultipliers: hideMultipliers,
        showPreview: showPreviewInSheet,
      ),
    );
    if (picked != null && picked != value) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasError = errorText != null;
    final borderWidth = hasError ? 1.5 : 1.0;
    final showPreview = previewBaseValue != null;
    final showPlaceholder = value == null && !showPreview;
    final shownText = showPlaceholder
        ? 'Nhập số tiền'
        : _vnFormatter.format(value);
    final previewBase = previewBaseValue;
    final previewReduction = value ?? 0;
    final previewResult = previewBase == null
        ? null
        : _previewResult(previewBase, previewReduction);
    final showReset = showPreview && previewReduction > 0 && onReset != null;
    final isReductionInput =
        reductionReferenceValue != null && reductionReferenceValue! > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _open(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError ? c.danger : c.border,
                  width: borderWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: hasError ? c.danger : c.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (showPreview && previewReduction > 0)
                        Text(
                          isReductionInput
                              ? '-${_vnFormatter.format(previewReduction)}$suffix'
                              : (_previewPercentText(
                                      previewBase ?? 0,
                                      previewReduction,
                                    ) ??
                                    ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isReductionInput ? c.danger : c.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: previewBase != null && previewResult != null
                            ? _CurrencyPreviewRow(
                                baseValue: _vnFormatter.format(previewBase),
                                resultValue: previewReduction == 0
                                    ? (previewZeroText ?? '0')
                                    : _vnFormatter.format(previewResult),
                                hasReduction: previewReduction > 0,
                                suffix: suffix,
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    shownText,
                                    style: TextStyle(
                                      color: showPlaceholder
                                          ? c.textMuted
                                          : c.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (!showPlaceholder) ...[
                                    const SizedBox(width: 4),
                                    Text(
                                      suffix,
                                      style: TextStyle(
                                        color: c.textMuted,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                      if (showReset) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: onReset,
                          tooltip: resetText ?? 'Reset',
                          icon: const Icon(TablerIcons.restore, size: 18),
                          style: IconButton.styleFrom(
                            foregroundColor: c.textMuted,
                            minimumSize: const Size.square(34),
                            fixedSize: const Size.square(34),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ] else if (!hideChevron)
                        Icon(
                          TablerIcons.chevron_down,
                          size: 18,
                          color: c.textMuted,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: hasError
              ? Padding(
                  key: const ValueKey('err'),
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      color: c.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox(key: ValueKey('ok'), height: 0),
        ),
      ],
    );
  }

  static int _previewResult(int base, int reduction) {
    final result = base - reduction;
    if (result < 0) return 0;
    if (result > base) return base;
    return result;
  }

  static String? _previewPercentText(int base, int reduction) {
    if (base <= 0 || reduction <= 0) return null;
    final raw = reduction / base * 100;
    final capped = raw > 100 ? 100.0 : raw;
    if (capped < 1) return 'Giảm <1%';
    final value = capped.round();
    return 'Giảm $value%';
  }
}

class _CurrencyPreviewRow extends StatelessWidget {
  const _CurrencyPreviewRow({
    required this.baseValue,
    required this.resultValue,
    required this.hasReduction,
    required this.suffix,
  });

  final String baseValue;
  final String resultValue;
  final bool hasReduction;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            Expanded(
              child: _CurrencyPreviewCell(
                value: '$baseValue$suffix',
                color: c.textMuted,
                alignment: Alignment.center,
                decoration: hasReduction ? TextDecoration.lineThrough : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                TablerIcons.arrow_right,
                color: c.textMuted,
                size: 15,
              ),
            ),
            Expanded(
              child: _CurrencyPreviewCell(
                value: hasReduction ? '$resultValue$suffix' : resultValue,
                color: hasReduction ? c.success : c.accent700,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrencyPreviewCell extends StatelessWidget {
  const _CurrencyPreviewCell({
    required this.value,
    required this.color,
    this.alignment = Alignment.centerLeft,
    this.decoration,
  });

  final String value;
  final Color color;
  final Alignment alignment;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      height: 38,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: c.pageBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              decoration: decoration,
              decorationColor: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stateful bottom-sheet body: holds the working int and renders the hero
/// number, the three quick-fill chips, the "Lưu" commit button, and the
/// 4×3 number pad. Pops the int on Lưu, or `null` on close / scrim tap.
class _CurrencySheetBody extends StatefulWidget {
  const _CurrencySheetBody({
    required this.label,
    required this.suffix,
    required this.initialValue,
    required this.saleReferenceValue,
    required this.salePercents,
    required this.reductionReferenceValue,
    required this.reductionPercents,
    required this.allowZero,
    required this.shrinkWrap,
    required this.previewBaseValue,
    required this.previewZeroText,
    required this.hideMultipliers,
    required this.showPreview,
  });

  final String label;
  final String suffix;
  final int initialValue;
  final int? saleReferenceValue;
  final List<int> salePercents;
  final int? reductionReferenceValue;
  final List<int> reductionPercents;
  final bool allowZero;
  final bool shrinkWrap;
  final int? previewBaseValue;
  final String? previewZeroText;
  final bool hideMultipliers;
  final bool showPreview;

  @override
  State<_CurrencySheetBody> createState() => _CurrencySheetBodyState();
}

class _CurrencySheetBodyState extends State<_CurrencySheetBody> {
  static const _maxDigits = 12;
  static final _vnFormatter = NumberFormat('#,###', 'vi_VN');

  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  int get _digitCount => _value == 0 ? 1 : _value.toString().length;
  bool get _usesReductionPercents =>
      widget.reductionReferenceValue != null &&
      widget.reductionReferenceValue! > 0 &&
      widget.reductionPercents.isNotEmpty;
  bool get _canReduce =>
      _usesReductionPercents ||
      (widget.saleReferenceValue != null &&
          widget.saleReferenceValue! > 0 &&
          widget.salePercents.isNotEmpty);

  void _appendDigit(int digit) {
    if (_digitCount >= _maxDigits) return;
    setState(() {
      _value = _value * 10 + digit;
    });
  }

  void _appendTripleZero() {
    if (_digitCount + 3 > _maxDigits) return;
    if (_value == 0) return;
    setState(() {
      _value = _value * 1000;
    });
  }

  void _backspace() {
    if (_value == 0) return;
    setState(() {
      _value = _value ~/ 10;
    });
  }

  void _multiply(int factor) {
    if (_value == 0) return;
    final next = _value * factor;
    if (next.toString().length > _maxDigits) return;
    setState(() {
      _value = next;
    });
  }

  void _reduceBy(int percent) {
    if (_usesReductionPercents) {
      final reference = widget.reductionReferenceValue!;
      setState(() {
        _value = _reductionAmountForPercent(reference, percent);
      });
      return;
    }
    final reference = widget.saleReferenceValue;
    if (reference == null || reference <= 0) return;
    setState(() {
      _value = _priceAfterReduction(reference, percent);
    });
  }

  static int _priceAfterReduction(int basePrice, int percent) {
    return (basePrice * (100 - percent) / 100).round();
  }

  static int _reductionAmountForPercent(int basePrice, int percent) {
    return (basePrice * percent / 100).round();
  }

  void _commit() {
    if (!widget.allowZero && _value <= 0) return;
    Navigator.of(context).pop<int?>(_value);
  }

  void _cancel() {
    Navigator.of(context).pop<int?>();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final media = MediaQuery.of(context);
    // Fill ~90% of the screen height so the pad sits comfortably above the
    // home indicator on iOS without the sheet feeling cramped.
    final isCompact = media.size.height < 700;
    final heroHeight = isCompact ? 72.0 : 128.0;
    final canCommit = widget.allowZero ? _value >= 0 : _value > 0;
    final canMultiply = _value > 0;
    final content = SingleChildScrollView(
      child: Column(
        children: [
          _buildTopBar(c),
          Text(
            widget.label,
            style: TextStyle(
              color: c.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: heroHeight,
            child: Center(child: _buildHero(c)),
          ),
          if (widget.showPreview && widget.previewBaseValue != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildPreview(c),
            ),
            const SizedBox(height: 12),
          ],
          if (!widget.hideMultipliers) ...[
            _buildChips(c, canMultiply: canMultiply),
            const SizedBox(height: 12),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCommitButton(c, enabled: canCommit),
          ),
          const SizedBox(height: 12),
          if (_canReduce) ...[_buildSaleChips(c), const SizedBox(height: 12)],
          _buildPad(c, keyHeight: isCompact ? 52 : 64),
          const SizedBox(height: 8),
        ],
      ),
    );

    return SafeArea(
      top: false,
      child: widget.shrinkWrap
          ? ConstrainedBox(
              constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
              child: content,
            )
          : SizedBox(height: media.size.height * 0.9, child: content),
    );
  }

  Widget _buildTopBar(KuruColors c) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Semantics(
          label: 'Close',
          button: true,
          child: IconButton(
            icon: Icon(TablerIcons.x, color: c.textMuted, size: 22),
            onPressed: _cancel,
          ),
        ),
      ],
    ),
  );

  Widget _buildHero(KuruColors c) {
    final formatted = _vnFormatter.format(_value);
    // Show "0" explicitly when empty.
    final isReduction = _usesReductionPercents && _value > 0;
    final display = _value == 0
        ? '0'
        : isReduction
        ? '-$formatted'
        : formatted;
    final heroColor = isReduction ? c.danger : c.primary;
    // Two separate Text widgets sharing the alphabetic baseline gives us
    // RichText-style superscript visuals AND a flat widget tree the test
    // harness can locate via find.text(...).
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              display,
              key: const ValueKey('currencyHero'),
              style: TextStyle(
                color: heroColor,
                fontSize: 50,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.suffix,
          style: TextStyle(
            color: heroColor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(KuruColors c) {
    final base = widget.previewBaseValue!;
    final result = _previewResult(base, _value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.borderSoft),
      ),
      child: _CurrencyPreviewRow(
        baseValue: _vnFormatter.format(base),
        resultValue: _value == 0
            ? (widget.previewZeroText ?? '0')
            : _vnFormatter.format(result),
        hasReduction: _value > 0,
        suffix: widget.suffix,
      ),
    );
  }

  static int _previewResult(int base, int reduction) {
    final result = base - reduction;
    if (result < 0) return 0;
    if (result > base) return base;
    return result;
  }

  Widget _buildSaleChips(KuruColors c) {
    final reference = _usesReductionPercents
        ? widget.reductionReferenceValue!
        : widget.saleReferenceValue!;
    final percents = _usesReductionPercents
        ? widget.reductionPercents
        : widget.salePercents;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giảm từ giá gốc ${_vnFormatter.format(reference)}${widget.suffix}',
            style: TextStyle(
              color: c.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < percents.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: _SaleChip(
                    label: 'Giảm ${percents[i]}%',
                    selected:
                        _value ==
                        (_usesReductionPercents
                            ? _reductionAmountForPercent(reference, percents[i])
                            : _priceAfterReduction(reference, percents[i])),
                    onTap: () => _reduceBy(percents[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChips(KuruColors c, {required bool canMultiply}) {
    // Each chip multiplies the current value by its factor; the label is
    // the resulting amount, vi-VN formatted (e.g. "400.000").
    final factors = [10, 100, 1000];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (var i = 0; i < factors.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: _QuickFillChip(
                label: '×${factors[i]}',
                onTap: canMultiply ? () => _multiply(factors[i]) : null,
                enabled: canMultiply,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommitButton(KuruColors c, {required bool enabled}) {
    final bg = enabled ? c.primary : c.primary.withValues(alpha: 0.4);
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? _commit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Lưu',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildPad(KuruColors c, {required double keyHeight}) {
    Widget digit(int d) => _PadKey(
      key: ValueKey('padKey-$d'),
      label: '$d',
      height: keyHeight,
      onTap: () => _appendDigit(d),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: digit(1)),
              Expanded(child: digit(2)),
              Expanded(child: digit(3)),
            ],
          ),
          Row(
            children: [
              Expanded(child: digit(4)),
              Expanded(child: digit(5)),
              Expanded(child: digit(6)),
            ],
          ),
          Row(
            children: [
              Expanded(child: digit(7)),
              Expanded(child: digit(8)),
              Expanded(child: digit(9)),
            ],
          ),
          Row(
            children: [
              Expanded(child: digit(0)),
              Expanded(
                child: _PadKey(
                  label: '000',
                  height: keyHeight,
                  onTap: _appendTripleZero,
                ),
              ),
              Expanded(
                child: _PadKey(
                  icon: TablerIcons.backspace,
                  height: keyHeight,
                  onTap: _backspace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaleChip extends StatelessWidget {
  const _SaleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final fg = selected ? c.danger : c.textSecondary;
    final bg = selected ? c.dangerSoft : c.surfaceHover;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(TablerIcons.discount_2, size: 14, color: fg),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single tile on the number pad. Either a label (digit / "000") or an
/// icon (backspace). Indigo on white, no border, ripple on tap.
class _PadKey extends StatelessWidget {
  const _PadKey({
    required this.onTap,
    required this.height,
    super.key,
    this.label,
    this.icon,
  }) : assert(
         label != null || icon != null,
         '_PadKey requires either label or icon',
       );

  final VoidCallback onTap;
  final double height;
  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: label != null
                ? Text(
                    label!,
                    style: TextStyle(
                      color: c.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Icon(icon, color: c.primary, size: 26),
          ),
        ),
      ),
    );
  }
}

/// Quick-fill chip: tap to multiply the current sheet value. Greyed and
/// non-interactive when [enabled] is false (e.g. current value == 0).
class _QuickFillChip extends StatelessWidget {
  const _QuickFillChip({
    required this.label,
    required this.enabled,
    this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final fg = enabled ? c.primary : c.textMuted;
    final bg = enabled ? c.primarySoft : c.surfaceHover;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
