import 'package:flutter/material.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

const kCuratedTimezones = <({String id, String label})>[
  (id: 'Asia/Ho_Chi_Minh', label: 'Việt Nam (GMT+7)'),
  (id: 'Asia/Bangkok', label: 'Thái Lan (GMT+7)'),
  (id: 'Asia/Singapore', label: 'Singapore (GMT+8)'),
  (id: 'Asia/Shanghai', label: 'Trung Quốc (GMT+8)'),
  (id: 'Asia/Tokyo', label: 'Nhật Bản (GMT+9)'),
  (id: 'Asia/Seoul', label: 'Hàn Quốc (GMT+9)'),
  (id: 'Asia/Manila', label: 'Philippines (GMT+8)'),
  (id: 'Australia/Sydney', label: 'Sydney (GMT+11)'),
  (id: 'Europe/London', label: 'Anh (GMT+0)'),
  (id: 'America/New_York', label: 'New York (GMT-5)'),
  (id: 'America/Los_Angeles', label: 'Los Angeles (GMT-8)'),
];

Future<String?> showTimezonePickerSheet(
  BuildContext context, {
  required String current,
}) {
  return showKModalSheet<String>(
    context: context,
    title: 'Múi giờ',
    builder: (sheetCtx) => _TimezonePickerBody(current: current),
  );
}

class _TimezonePickerBody extends StatefulWidget {
  const _TimezonePickerBody({required this.current});
  final String current;
  @override
  State<_TimezonePickerBody> createState() => _TimezonePickerBodyState();
}

class _TimezonePickerBodyState extends State<_TimezonePickerBody> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = kCuratedTimezones.where((tz) {
      final q = _query.toLowerCase();
      return tz.id.toLowerCase().contains(q) ||
          tz.label.toLowerCase().contains(q);
    }).toList();
    return SizedBox(
      height: 480,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm múi giờ',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final tz = filtered[i];
                final selected = tz.id == widget.current;
                return ListTile(
                  title: Text(tz.label),
                  subtitle: Text(tz.id, style: const TextStyle(fontSize: 11)),
                  trailing: selected ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(tz.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
