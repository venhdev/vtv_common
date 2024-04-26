// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'shipping_entity.dart';

import 'order_entity.dart';
import 'transport_entity.dart';

//! OrderResp with one OrderEntity
//! MultiOrderResp with List<OrderEntity>
class OrderDetailEntity extends Equatable {
  final OrderEntity order;
  final ShippingEntity shipping;
  final TransportEntity? transport;
  final int? totalPoint; // current loyalty point

  const OrderDetailEntity({
    required this.order,
    required this.shipping,
    required this.transport,
    required this.totalPoint,
  });

  OrderDetailEntity copyWith({
    OrderEntity? order,
    ShippingEntity? shipping,
    TransportEntity? transport,
    int? totalPoint,
  }) {
    return OrderDetailEntity(
      order: order ?? this.order,
      shipping: shipping ?? this.shipping,
      transport: transport ?? this.transport,
      totalPoint: totalPoint ?? this.totalPoint,
    );
  }

  factory OrderDetailEntity.fromMap(Map<String, dynamic> map) {
    return OrderDetailEntity(
      order: OrderEntity.fromMap(map['orderDTO'] as Map<String, dynamic>),
      shipping: ShippingEntity.fromMap(map['shippingDTO'] as Map<String, dynamic>),
      transport:
          (map['transportDTO'] != null) ? TransportEntity.fromMap(map['transportDTO'] as Map<String, dynamic>) : null,
      totalPoint: map['totalPoint'] as int?,
    );
  }

  factory OrderDetailEntity.fromJson(String source) =>
      OrderDetailEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [order, shipping];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderDTO': order.toMap(),
      'shippingDTO': shipping.toMap(),
      'transportDTO': transport?.toMap(),
      'totalPoint': totalPoint,
    };
  }

  String toJson() => json.encode(toMap());
}
