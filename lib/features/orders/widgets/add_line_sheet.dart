import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';

/// Returns the line to add/update, or null if cancelled.
Future<OrderLineItem?> showAddLineSheet(
  BuildContext context, {
  OrderLineItem? edit,
}) {
  return showKModalSheet<OrderLineItem>(
    context: context,
    title: edit == null
        ? AppLocalizations.of(context).addLineSheetTitle
        : AppLocalizations.of(context).addLineSheetEditTitle,
    builder: (ctx) => _AddLineSheetBody(edit: edit),
  );
}

class _AddLineSheetBody extends ConsumerStatefulWidget {
  const _AddLineSheetBody({this.edit});
  final OrderLineItem? edit;

  @override
  ConsumerState<_AddLineSheetBody> createState() => _AddLineSheetBodyState();
}

class _AddLineSheetBodyState extends ConsumerState<_AddLineSheetBody> {
  final TextEditingController _search = TextEditingController();
  ProductSummary? _picked;
  late final TextEditingController _qty;
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    final qtyVal = widget.edit?.qty ?? 1;
    _qty = TextEditingController(
      text: qtyVal.truncateToDouble() == qtyVal
          ? qtyVal.toInt().toString()
          : qtyVal.toString(),
    );
    final priceVal = widget.edit?.unitPrice ?? 0;
    _price = TextEditingController(
      text: priceVal.truncateToDouble() == priceVal
          ? priceVal.toInt().toString()
          : priceVal.toString(),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isEdit = widget.edit != null;
    if (isEdit || _picked != null) {
      return _stageTwo(l);
    }
    return _stageOne(l);
  }

  Widget _stageOne(AppLocalizations l) {
    final filter = ProductListFilter(search: _search.text);
    final products = ref.watch(productListProvider(filter));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KSearchBar(
          controller: _search,
          hint: l.addLineSheetSearchHint,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 320,
          child: products.when(
            data: (page) {
              if (page.items.isEmpty) {
                return Center(child: Text(l.addLineSheetEmpty));
              }
              return ListView.builder(
                itemCount: page.items.length,
                itemBuilder: (_, i) {
                  final p = page.items[i];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.sellPricePerUnit}'),
                    onTap: () => setState(() {
                      _picked = p;
                      _price.text = p.sellPricePerUnit.toString();
                    }),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
          ),
        ),
      ],
    );
  }

  Widget _stageTwo(AppLocalizations l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.edit?.productName ?? _picked?.name ?? ''),
        const SizedBox(height: 12),
        KTextField(
          controller: _qty,
          label: l.addLineSheetQty,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        KTextField(
          controller: _price,
          label: l.addLineSheetUnitPrice,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            final qty = double.tryParse(_qty.text) ?? 0;
            final price = double.tryParse(_price.text) ?? 0;
            if (qty <= 0 || price < 0) return;
            final item = OrderLineItem(
              productId: widget.edit?.productId ?? _picked!.id,
              variantId: widget.edit?.variantId,
              productName: widget.edit?.productName ?? _picked!.name,
              variantName: widget.edit?.variantName,
              imageUrl: widget.edit?.imageUrl ?? _picked?.imageUrl,
              baseUnitCode: widget.edit?.baseUnitCode ?? _picked!.baseUnitCode,
              qty: qty,
              unitPrice: price,
              discountType: widget.edit?.discountType,
              discountValue: widget.edit?.discountValue,
            );
            Navigator.of(context).pop(item);
          },
          child: Text(
            widget.edit == null ? l.addLineSheetAdd : l.addLineSheetUpdate,
          ),
        ),
      ],
    );
  }
}
