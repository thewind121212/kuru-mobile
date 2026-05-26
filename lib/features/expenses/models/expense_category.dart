// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/parsing/parse_date.dart';

class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.orgId,
    required this.name,
    required this.frequency,
    required this.isSystem,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    this.defaultAmount,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      frequency: json['frequency'] as String? ?? 'IRREGULAR',
      defaultAmount: _parseAmount(json['defaultAmount']),
      isSystem: json['isSystem'] as bool? ?? false,
      isDelete: json['isDelete'] as bool? ?? false,
      createdAt: parseProtoDate(json['createdAt']),
      updatedAt: parseProtoDate(json['updatedAt']),
    );
  }

  final String id;
  final String orgId;
  final String name;
  final String frequency;
  final int? defaultAmount;
  final bool isSystem;
  final bool isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IconData get icon {
    final normalized = name.toLowerCase();
    if (normalized.contains('hàng') ||
        normalized.contains('kho') ||
        normalized.contains('inventory')) {
      return TablerIcons.package_import;
    }
    if (normalized.contains('mặt bằng') ||
        normalized.contains('rent') ||
        normalized.contains('nhà')) {
      return TablerIcons.building_store;
    }
    if (normalized.contains('lương') || normalized.contains('salary')) {
      return TablerIcons.users;
    }
    if (normalized.contains('ship') ||
        normalized.contains('vận chuyển') ||
        normalized.contains('delivery')) {
      return TablerIcons.truck_delivery;
    }
    if (normalized.contains('điện') ||
        normalized.contains('nước') ||
        normalized.contains('utility')) {
      return TablerIcons.bulb;
    }
    if (normalized.contains('marketing') || normalized.contains('quảng cáo')) {
      return TablerIcons.speakerphone;
    }
    return TablerIcons.receipt;
  }

  static int? _parseAmount(Object? raw) {
    if (raw == null) return null;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw.toString());
  }
}
