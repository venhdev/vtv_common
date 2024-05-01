import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core/constants/types.dart';
import 'transport_handle_entity.dart';

class TransportEntity {
  final String transportId;
  final String wardCodeShop;
  final String wardCodeCustomer;
  final String orderId;
  final int? shopId;
  final String shippingMethod;
  final OrderStatus status;
  final int totalTransportHandle;
  final List<TransportHandleEntity> transportHandles;

  TransportEntity({
    required this.transportId,
    required this.wardCodeShop,
    required this.wardCodeCustomer,
    required this.orderId,
    required this.shopId,
    required this.shippingMethod,
    required this.status,
    required this.totalTransportHandle,
    required this.transportHandles,
  });

  TransportEntity copyWith({
    String? transportId,
    String? wardCodeShop,
    String? wardCodeCustomer,
    String? orderId,
    int? shopId,
    String? shippingMethod,
    OrderStatus? status,
    int? totalTransportHandle,
    List<TransportHandleEntity>? transportHandles,
  }) {
    return TransportEntity(
      transportId: transportId ?? this.transportId,
      wardCodeShop: wardCodeShop ?? this.wardCodeShop,
      wardCodeCustomer: wardCodeCustomer ?? this.wardCodeCustomer,
      orderId: orderId ?? this.orderId,
      shopId: shopId ?? this.shopId,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      status: status ?? this.status,
      totalTransportHandle: totalTransportHandle ?? this.totalTransportHandle,
      transportHandles: transportHandles ?? this.transportHandles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transportId': transportId,
      'wardCodeShop': wardCodeShop,
      'wardCodeCustomer': wardCodeCustomer,
      'orderId': orderId,
      'shopId': shopId,
      'shippingMethod': shippingMethod,
      'status': status.name,
      'totalTransportHandle': totalTransportHandle,
      'transportHandleDTOs': transportHandles.map((x) => x.toMap()).toList(),
    };
  }

  factory TransportEntity.fromMap(Map<String, dynamic> map) {
    return TransportEntity(
      transportId: map['transportId'] as String,
      wardCodeShop: map['wardCodeShop'] as String,
      wardCodeCustomer: map['wardCodeCustomer'] as String,
      orderId: map['orderId'] as String,
      shopId: map['shopId'] as int?,
      shippingMethod: map['shippingMethod'] as String,
      // status: map['status'] as String?,
      status: OrderStatus.values.firstWhere((e) => e.name == map['status'] as String),
      totalTransportHandle: map['totalTransportHandle'] as int,
      // transportHandleDtOs: List<TransportHandleEntity>.from(
      //   (map['transportHandleDTOs'] as List<dynamic>?)!.map<TransportHandleEntity>(
      //     (x) => TransportHandleEntity.fromMap(x as Map<String, dynamic>),
      //   ),
      // ),
      transportHandles: (map['transportHandleDTOs'] as List<dynamic>)
          .map<TransportHandleEntity>(
            (x) => TransportHandleEntity.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransportEntity.fromJson(String source) =>
      TransportEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransportEntity(transportId: $transportId, wardCodeShop: $wardCodeShop, wardCodeCustomer: $wardCodeCustomer, orderId: $orderId, shopId: $shopId, shippingMethod: $shippingMethod, status: $status, totalTransportHandle: $totalTransportHandle, transportHandleDtOs: $transportHandles)';
  }

  @override
  bool operator ==(covariant TransportEntity other) {
    if (identical(this, other)) return true;

    return other.transportId == transportId &&
        other.wardCodeShop == wardCodeShop &&
        other.wardCodeCustomer == wardCodeCustomer &&
        other.orderId == orderId &&
        other.shopId == shopId &&
        other.shippingMethod == shippingMethod &&
        other.status == status &&
        other.totalTransportHandle == totalTransportHandle &&
        listEquals(other.transportHandles, transportHandles);
  }

  @override
  int get hashCode {
    return transportId.hashCode ^
        wardCodeShop.hashCode ^
        wardCodeCustomer.hashCode ^
        orderId.hashCode ^
        shopId.hashCode ^
        shippingMethod.hashCode ^
        status.hashCode ^
        totalTransportHandle.hashCode ^
        transportHandles.hashCode;
  }
}
