import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KSettingsSection extends StatelessWidget {
  const KSettingsSection({
    required this.header,
    required this.children,
    super.key,
  });

  final String header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final divided = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      divided.add(children[i]);
      if (i < children.length - 1) {
        divided.add(
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(height: 1, thickness: 0.5, color: c.borderSoft),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 10),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.textMuted,
              ),
            ),
          )
        else
          const SizedBox(height: 18),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: c.surfaceElev,
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: divided),
        ),
      ],
    );
  }
}
