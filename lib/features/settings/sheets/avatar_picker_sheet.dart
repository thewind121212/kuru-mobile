import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

class AvatarSelection {
  const AvatarSelection({required this.style, required this.seed});
  final String? style;
  final String? seed;
}

// Canonical list — mirrors kuru-web's `AVATAR_STYLES` in
// fe/src/core-design/utils/avatar.ts so a profile picked on the web
// renders consistently in the mobile app and vice versa.
const _dicebearStyles = <({String id, String label})>[
  (id: 'fun-emoji', label: 'Fun Emoji'),
  (id: 'thumbs', label: 'Thumbs'),
  (id: 'pixel-art', label: 'Pixel Art'),
  (id: 'bottts', label: 'Bottts'),
  (id: 'shapes', label: 'Shapes'),
  (id: 'adventurer', label: 'Adventure'),
];

Future<AvatarSelection?> showAvatarPickerSheet(
  BuildContext context, {
  required String currentName,
  String? currentStyle,
  String? currentSeed,
}) {
  return showKModalSheet<AvatarSelection>(
    context: context,
    title: 'Ảnh đại diện',
    builder: (sheetCtx) => _AvatarPickerBody(
      currentName: currentName,
      initialStyle: currentStyle,
      initialSeed: currentSeed,
    ),
  );
}

class _AvatarPickerBody extends ConsumerStatefulWidget {
  const _AvatarPickerBody({
    required this.currentName,
    this.initialStyle,
    this.initialSeed,
  });
  final String currentName;
  final String? initialStyle;
  final String? initialSeed;
  @override
  ConsumerState<_AvatarPickerBody> createState() => _AvatarPickerBodyState();
}

String _randomSeed() {
  final r = Random();
  // Short alphanumeric seed — enough variety for dicebear's renderer.
  const alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(10, (_) => alphabet[r.nextInt(alphabet.length)]).join();
}

class _AvatarPickerBodyState extends ConsumerState<_AvatarPickerBody>
    with SingleTickerProviderStateMixin {
  // Upload tab disabled until BE binds /UploadUserAvatar (the multer
  // helper exists in be/core/file-service/user-avatar.ts but no route
  // wires it). Restore the tab + image_picker deps when BE ships it.
  late final TabController _tabs = TabController(length: 2, vsync: this);
  String? _style;
  String? _seed;

  @override
  void initState() {
    super.initState();
    _style = widget.initialStyle;
    _seed = widget.initialSeed ?? widget.currentName;
    _tabs.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Column(
        children: [
          TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'Chữ cái'),
              Tab(text: 'Hình vẽ'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [_initialsTab(), _dicebearTab()],
            ),
          ),
          if (_tabs.index == 1)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _seed = _randomSeed()),
                      icon: const Icon(Icons.casino_outlined),
                      label: const Text('Đổi ngẫu nhiên'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: _style == null
                          ? null
                          : () => Navigator.of(context).pop(
                              AvatarSelection(
                                style: _style,
                                seed: _seed ?? widget.currentName,
                              ),
                            ),
                      child: const Text('Dùng kiểu này'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _initialsTab() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          KAvatar(name: widget.currentName, size: 96),
          const SizedBox(height: 16),
          const Text('Tạo từ tên hiển thị'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(const AvatarSelection(style: null, seed: null)),
            child: const Text('Dùng chữ cái'),
          ),
        ],
      ),
    );
  }

  Widget _dicebearTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _dicebearStyles.length,
      itemBuilder: (_, i) {
        final s = _dicebearStyles[i];
        final selected = _style == s.id;
        // Every tile shares the same _seed so a single "Đổi ngẫu nhiên"
        // tap repaints every preview at once. Selecting a tile is a
        // pure style swap; the seed never changes from tapping.
        final tileSeed = _seed ?? widget.currentName;
        return GestureDetector(
          onTap: () {
            if (selected) return;
            setState(() => _style = s.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: selected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: KAvatar(
                        // ValueKey forces a fresh Element + ImageStream
                        // whenever the seed changes so a reroll really
                        // refetches the new dicebear URL.
                        key: ValueKey('${s.id}-$tileSeed'),
                        name: widget.currentName,
                        size: 64,
                        avatarStyle: s.id,
                        avatarSeed: tileSeed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.label,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
