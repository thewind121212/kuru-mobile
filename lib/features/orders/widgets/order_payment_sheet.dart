import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';

Future<OrderPaymentInput?> showOrderPaymentSheet(
  BuildContext context, {
  required double defaultAmount,
}) {
  return showKModalSheet<OrderPaymentInput>(
    context: context,
    title: AppLocalizations.of(context).orderPaymentSheetTitle,
    builder: (sheetCtx) => _PaymentSheetBody(defaultAmount: defaultAmount),
  );
}

class _PaymentSheetBody extends StatefulWidget {
  const _PaymentSheetBody({required this.defaultAmount});
  final double defaultAmount;

  @override
  State<_PaymentSheetBody> createState() => _PaymentSheetBodyState();
}

class _PaymentSheetBodyState extends State<_PaymentSheetBody> {
  late OrderPaymentMethod _method = OrderPaymentMethod.cash;
  late final TextEditingController _amount = TextEditingController(
    text: NumberFormat('#').format(widget.defaultAmount),
  );
  final TextEditingController _ref = TextEditingController();
  final TextEditingController _note = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _ref.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<OrderPaymentMethod>(
          initialValue: _method,
          decoration: InputDecoration(labelText: l.orderPaymentSheetMethod),
          items: [
            for (final m in OrderPaymentMethod.values)
              DropdownMenuItem(value: m, child: Text(_methodLabel(l, m))),
          ],
          onChanged: (m) =>
              setState(() => _method = m ?? OrderPaymentMethod.cash),
        ),
        const SizedBox(height: 12),
        KTextField(
          controller: _amount,
          label: l.orderPaymentSheetAmount,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        KTextField(controller: _ref, label: l.orderPaymentSheetReference),
        const SizedBox(height: 12),
        KTextField(controller: _note, label: l.orderPaymentSheetNote),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            final amount =
                double.tryParse(_amount.text.replaceAll(',', '')) ?? 0;
            Navigator.of(context).pop(
              OrderPaymentInput(
                method: _method,
                amount: amount,
                reference: _ref.text.trim().isEmpty ? null : _ref.text.trim(),
                note: _note.text.trim().isEmpty ? null : _note.text.trim(),
              ),
            );
          },
          child: Text(l.orderPaymentSheetConfirm),
        ),
      ],
    );
  }

  String _methodLabel(AppLocalizations l, OrderPaymentMethod m) => switch (m) {
    OrderPaymentMethod.cash => l.orderPaymentMethodCash,
    OrderPaymentMethod.bankTransfer => l.orderPaymentMethodBankTransfer,
    OrderPaymentMethod.card => l.orderPaymentMethodCard,
    OrderPaymentMethod.other => l.orderPaymentMethodOther,
  };
}
