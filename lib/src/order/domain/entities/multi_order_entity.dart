import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order_entity.dart';

class MultiOrderEntity extends Equatable {
  final List<OrderEntity> orders;
  final int count;
  final int totalPayment;
  final int totalPrice;

  const MultiOrderEntity({
    required this.orders,
    required this.count,
    required this.totalPayment,
    required this.totalPrice,
  });

  MultiOrderEntity copyWith({
    List<OrderEntity>? orders,
    int? count,
    int? totalPayment,
    int? totalPrice,
  }) {
    return MultiOrderEntity(
      orders: orders ?? this.orders,
      count: count ?? this.count,
      totalPayment: totalPayment ?? this.totalPayment,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  factory MultiOrderEntity.fromMap(Map<String, dynamic> map) {
    return MultiOrderEntity(
      orders: (map['orderDTOs'] as List<dynamic>)
          .map(
            (e) => OrderEntity.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
      count: map['count'] as int,
      totalPayment: map['totalPayment'] as int,
      totalPrice: map['totalPrice'] as int,
    );
  }

  factory MultiOrderEntity.fromJson(String source) =>
      MultiOrderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      orders,
      count,
      totalPayment,
      totalPrice,
    ];
  }

  @override
  bool get stringify => true;
}
