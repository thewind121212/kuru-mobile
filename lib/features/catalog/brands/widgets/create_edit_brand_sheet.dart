// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';

sealed class BrandSheetMode {
  const BrandSheetMode();
}

class CreateBrand extends BrandSheetMode {
  const CreateBrand();
}

class EditBrand extends BrandSheetMode {
  const EditBrand({required this.brand});
  final gen.BrandOverviewItem brand;
}

/// Shows the Create or Edit brand sheet. Returns `true` after a successful
/// save; `null` on cancel / dismiss.
Future<bool?> showCreateEditBrandSheet({
  required BuildContext context,
  required BrandSheetMode mode,
}) {
  final l = AppLocalizations.of(context);
  final title = switch (mode) {
    CreateBrand() => l.brandCreateTitle,
    EditBrand() => l.brandEditTitle,
  };
  final confirmLabel = switch (mode) {
    CreateBrand() => l.brandCreateCta,
    EditBrand() => l.brandEditCta,
  };
  final key = GlobalKey<_BrandFormState>();
  return showKModalSheet<bool>(
    context: context,
    title: title,
    confirmLabel: confirmLabel,
    onConfirm: () async => key.currentState?._submit() ?? false,
    builder: (_) => _BrandForm(key: key, mode: mode),
  );
}

class _BrandForm extends ConsumerStatefulWidget {
  const _BrandForm({required this.mode, super.key});
  final BrandSheetMode mode;

  @override
  ConsumerState<_BrandForm> createState() => _BrandFormState();
}

class _BrandFormState extends ConsumerState<_BrandForm> {
  late final TextEditingController _name;
  String? _error;

  @override
  void initState() {
    super.initState();
    final m = widget.mode;
    _name = TextEditingController(text: m is EditBrand ? m.brand.name : '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<bool> _submit() async {
    final l = AppLocalizations.of(context);
    final value = _name.text.trim();
    if (value.isEmpty) {
      setState(() => _error = l.brandFieldNameRequired);
      return false;
    }
    setState(() => _error = null);
    final repo = ref.read(brandRepositoryProvider);
    final result = switch (widget.mode) {
      CreateBrand() => await repo.create(name: value),
      EditBrand(brand: final b) => await repo.update(
        brandId: b.id,
        name: value,
      ),
    };
    if (result is ApiSuccess) {
      return true;
    }
    // ApiFailure — handle ALL error types inside the sheet without throwing.
    // KModalSheet._handleConfirm has no try/catch; any throw wedges the busy
    // state forever. BadRequestException → field errorText (sheet stays open).
    // Network/timeout/server → SnackBar via ScaffoldMessenger.
    final err = (result as ApiFailure).err;
    if (err is BadRequestException) {
      setState(() => _error = err.message);
    } else {
      final msg = err is NetworkException || err is TimeoutException
          ? err.message
          : l.brandNotifyServer;
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: KTextField(
        controller: _name,
        label: l.brandFieldNameLabel,
        placeholder: l.brandFieldNameHint,
        maxLength: 120,
        errorText: _error,
      ),
    );
  }
}
