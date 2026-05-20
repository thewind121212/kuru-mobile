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
        divided.add(Divider(height: 1, thickness: 1, color: c.borderSoft));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Text(
              header.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: c.surfaceElev,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: divided),
        ),
      ],
    );
  }
}
