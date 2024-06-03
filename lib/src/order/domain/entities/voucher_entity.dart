// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../core/constants/types.dart';
import '../../../core/utils.dart';

class VoucherEntity extends Equatable {
  final int? voucherId;
  final Status? status;
  final String code;
  final String name;
  final String description;
  final int discount;
  final int quantity;
  final DateTime startDate;
  final DateTime endDate;
  final int? quantityUsed;
  final VoucherType type;

  const VoucherEntity({
    this.voucherId,
    this.status,
    required this.code,
    required this.name,
    required this.description,
    required this.discount,
    required this.quantity,
    required this.startDate,
    required this.endDate,
    this.quantityUsed,
    required this.type,
  });
  // e.g: CUS1-VOUCHER_CODE, ABCDE-VOUCHER-CODE
  // delete CUS1- prefix
  String get codeNoPrefix => code.split('-').last;

  factory VoucherEntity.addInit([VoucherType type = VoucherType.MONEY_SHOP, int discount = 1000]) {
    final today = DateTimeUtils.today();
    return VoucherEntity(
      voucherId: null,
      status: null,
      code: '',
      name: '',
      description: '',
      discount: discount,
      quantity: 10,
      startDate: today.add(const Duration(days: 1)),
      endDate: today.add(const Duration(days: 7)),
      quantityUsed: null,
      type: type,
    );
  }

  @override
  List<Object?> get props {
    return [
      voucherId,
      status,
      code,
      name,
      description,
      discount,
      quantity,
      startDate,
      endDate,
      quantityUsed,
      type,
    ];
  }

  VoucherEntity copyWith({
    int? voucherId,
    Status? status,
    String? code,
    String? name,
    String? description,
    int? discount,
    int? quantity,
    DateTime? startDate,
    DateTime? endDate,
    int? quantityUsed,
    VoucherType? type,
  }) {
    return VoucherEntity(
      voucherId: voucherId ?? this.voucherId,
      status: status ?? this.status,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      quantityUsed: quantityUsed ?? this.quantityUsed,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'voucherId': voucherId,
      'code': code,
      'name': name,
      'description': description,
      'discount': discount,
      'quantity': quantity,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      // 'type': type.name,
      'type': type == VoucherType.PERCENTAGE_SHOP ? 'percent' : 'money',
      // 'status': status,
      // 'quantityUsed': quantityUsed, //server no need
    };
  }

  factory VoucherEntity.fromMap(Map<String, dynamic> map) {
    return VoucherEntity(
      voucherId: map['voucherId'] as int?,
      status: Status.values.firstWhere((e) => e.name == map['status'] as String),
      code: map['code'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      discount: map['discount'] as int,
      quantity: map['quantity'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      quantityUsed: map['quantityUsed'] as int,
      type: VoucherType.values.byName(map['type'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory VoucherEntity.fromJson(String source) => VoucherEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<VoucherEntity> fromList(List<dynamic> list) {
    return list.map((e) => VoucherEntity.fromMap(e)).toList();
  }

  @override
  bool get stringify => true;
}
