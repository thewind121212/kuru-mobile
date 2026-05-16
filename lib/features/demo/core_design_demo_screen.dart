import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/catalog/k_category_card.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_danger_btn.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/input/k_select.dart';
import 'package:kuru_mobile/design/core/input/k_tab_nav.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/input/k_textarea.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';
import 'package:kuru_mobile/design/core/modal/k_color_picker.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/design/core/modal/k_icon_picker.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/design/core/modal/k_popup_menu.dart';

/// Debug-only sandbox that renders every core-design widget in one
/// scrollable column. Used for manual visual verification — the unit/widget
/// tests cover behavior, this screen covers "does it look right?".
class CoreDesignDemoScreen extends StatefulWidget {
  const CoreDesignDemoScreen({super.key});

  @override
  State<CoreDesignDemoScreen> createState() => _CoreDesignDemoScreenState();
}

class _CoreDesignDemoScreenState extends State<CoreDesignDemoScreen> {
  String _tab = 'all';
  String _color = 'red-400';
  String _icon = 'box';
  String? _status = 'active';
  final _textCtl = TextEditingController(text: 'Coffee Co');
  final _textareaCtl = TextEditingController();

  @override
  void dispose() {
    _textCtl.dispose();
    _textareaCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KPageHeader(
                title: 'Core Design',
                subtitle: 'Debug sandbox',
                actions: [
                  KIconBtn(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
              _section(c, 'Feedback', _feedbackSection(c)),
              _section(c, 'Input', _inputSection(c)),
              _section(c, 'Layout', _layoutSection(c)),
              _section(c, 'Modal', _modalSection(context, c)),
              _section(c, 'Catalog', _catalogSection(c)),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(KuruColors c, String title, Widget body) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            body,
          ],
        ),
      );

  Widget _feedbackSection(KuruColors c) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spinner'),
          SizedBox(height: 4),
          Row(children: [
            KSpinner(),
            SizedBox(width: 12),
            KSpinner(size: 24),
            SizedBox(width: 12),
            KSpinner(size: 32),
          ]),
          SizedBox(height: 16),
          Text('Skeleton'),
          SizedBox(height: 4),
          KSkeleton(width: double.infinity),
          SizedBox(height: 8),
          Row(children: [
            KSkeleton.circle(40),
            SizedBox(width: 12),
            Expanded(child: KSkeleton(width: double.infinity, height: 12)),
          ]),
          SizedBox(height: 16),
          Text('Badge'),
          SizedBox(height: 4),
          Wrap(spacing: 8, runSpacing: 8, children: [
            KBadge(label: 'neutral'),
            KBadge(label: 'info', tone: KBadgeTone.info),
            KBadge(label: 'success', tone: KBadgeTone.success),
            KBadge(label: 'warning', tone: KBadgeTone.warning),
            KBadge(label: 'danger', tone: KBadgeTone.danger),
            KBadge(label: 'accent', tone: KBadgeTone.accent),
          ]),
          SizedBox(height: 16),
          Text('EmptyState'),
          SizedBox(height: 4),
          SizedBox(
            height: 280,
            child: KEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No brands yet',
              subtitle: 'Add your first brand to get started',
            ),
          ),
        ],
      );

  Widget _inputSection(KuruColors c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SearchBar'),
          const SizedBox(height: 4),
          KSearchBar(hint: 'Search brands', onChanged: (_) {}),
          const SizedBox(height: 16),
          const Text('Buttons'),
          const SizedBox(height: 4),
          KSecondaryBtn(label: 'Secondary', onPressed: () {}),
          const SizedBox(height: 8),
          KDangerBtn(label: 'Danger', onPressed: () {}),
          const SizedBox(height: 8),
          Row(children: [
            KIconBtn(icon: const Icon(Icons.add), onPressed: () {}),
            const SizedBox(width: 8),
            KIconBtn(icon: const Icon(Icons.edit), onPressed: () {}),
            const SizedBox(width: 8),
            KIconBtn(icon: const Icon(Icons.delete), onPressed: () {}),
          ]),
          const SizedBox(height: 16),
          const Text('TabNav'),
          const SizedBox(height: 4),
          KTabNav<String>(
            tabs: const [
              KTabItem(id: 'all', label: 'All'),
              KTabItem(id: 'l1', label: 'Layer 1'),
              KTabItem(id: 'l2', label: 'Layer 2'),
              KTabItem(id: 'l3', label: 'Layer 3'),
              KTabItem(id: 'l4', label: 'Layer 4'),
              KTabItem(id: 'l5', label: 'Layer 5'),
            ],
            active: _tab,
            onChange: (id) => setState(() => _tab = id),
          ),
          const SizedBox(height: 16),
          const Text('TextField'),
          const SizedBox(height: 4),
          KTextField(
            label: 'Brand name',
            controller: _textCtl,
            placeholder: 'e.g. Coffee Co',
          ),
          const SizedBox(height: 16),
          const Text('Textarea'),
          const SizedBox(height: 4),
          KTextarea(
            label: 'Description',
            controller: _textareaCtl,
            placeholder: 'A short description...',
            maxLength: 200,
          ),
          const SizedBox(height: 16),
          const Text('Select'),
          const SizedBox(height: 4),
          KSelect<String>(
            label: 'Status',
            value: _status,
            options: const [
              KSelectOption(value: 'active', label: 'Active'),
              KSelectOption(value: 'inactive', label: 'Inactive'),
            ],
            onChanged: (v) => setState(() => _status = v),
          ),
        ],
      );

  Widget _layoutSection(KuruColors c) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          'PageHeader rendered at top of this screen — scroll to see.',
        ),
      );

  Widget _catalogSection(KuruColors c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ListRow'),
          const SizedBox(height: 4),
          KListRow(
            leading: const Icon(Icons.bookmark, color: Colors.orange),
            title: 'Coffee Co',
            subtitle: '15 products',
            trailing: KIconBtn(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
            onTap: () {},
          ),
          const SizedBox(height: 16),
          const Text('PopupMenu (long-press the row →)'),
          const SizedBox(height: 4),
          KPopupMenu<String>(
            actions: const [
              KActionItem(id: 'edit', label: 'Edit', icon: Icons.edit),
              KActionItem(
                id: 'duplicate',
                label: 'Duplicate',
                icon: Icons.copy,
              ),
              KActionItem(
                id: 'delete',
                label: 'Delete',
                icon: Icons.delete_outline,
                danger: true,
              ),
            ],
            onSelected: (_) {},
            child: KListRow(
              leading: const Icon(Icons.local_cafe, color: Colors.brown),
              title: 'Espresso',
              subtitle: 'Long-press for native menu',
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),
          const Text('CategoryCard'),
          const SizedBox(height: 4),
          KCategoryCard(
            icon: Icons.coffee,
            iconBg: Colors.brown,
            name: 'Coffee',
            stats: const [
              KCategoryCardStat(label: 'Items', value: '15'),
              KCategoryCardStat(label: 'Value', value: '₫1.2M'),
            ],
            lowStockBadge: const KBadge(
              label: '2 low stock',
              tone: KBadgeTone.danger,
              leadingIcon: Icons.warning_amber_rounded,
            ),
            menu: KIconBtn(
              icon: const Icon(Icons.more_vert),
              size: 32,
              onPressed: () {},
            ),
            onTap: () {},
          ),
        ],
      );

  Widget _modalSection(BuildContext context, KuruColors c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KSecondaryBtn(
            label: 'Open form sheet',
            fullWidth: false,
            onPressed: () => showKModalSheet<void>(
              context: context,
              title: 'Create brand',
              subtitle: 'Add a brand to your catalog',
              confirmLabel: 'Save',
              onConfirm: () async => true,
              builder: (_) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('(form fields would go here)'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          KDangerBtn(
            label: 'Open confirm dialog (destructive)',
            fullWidth: false,
            onPressed: () => showKConfirmDialog(
              context: context,
              title: 'Delete brand?',
              subtitle: 'This action cannot be undone.',
              confirmLabel: 'Delete',
            ),
          ),
          const SizedBox(height: 8),
          KSecondaryBtn(
            label: 'Open action sheet',
            fullWidth: false,
            onPressed: () => showKActionSheet<String>(
              context: context,
              title: 'BRAND ACTIONS',
              actions: const [
                KActionItem(id: 'edit', label: 'Edit', icon: Icons.edit),
                KActionItem(
                  id: 'duplicate',
                  label: 'Duplicate',
                  icon: Icons.copy,
                ),
                KActionItem(
                  id: 'delete',
                  label: 'Delete',
                  icon: Icons.delete_outline,
                  danger: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          KSecondaryBtn(
            label: 'Pick color (current: $_color)',
            fullWidth: false,
            onPressed: () async {
              final picked =
                  await showKColorPicker(context: context, selected: _color);
              if (picked != null) setState(() => _color = picked);
            },
          ),
          const SizedBox(height: 8),
          KSecondaryBtn(
            label: 'Pick icon (current: $_icon)',
            fullWidth: false,
            onPressed: () async {
              final picked =
                  await showKIconPicker(context: context, selected: _icon);
              if (picked != null) setState(() => _icon = picked);
            },
          ),
        ],
      );
}
