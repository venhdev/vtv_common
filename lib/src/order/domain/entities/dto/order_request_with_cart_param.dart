// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/types.dart';

class OrderRequestWithCartParam {
  final int addressId;
  final String? systemVoucherCode;
  final String? shopVoucherCode;
  final bool useLoyaltyPoint;
  final PaymentType paymentMethod;
  final String shippingMethod;
  String note;
  final List<String?> cartIds;

  OrderRequestWithCartParam({
    required this.addressId,
    this.systemVoucherCode,
    this.shopVoucherCode,
    required this.useLoyaltyPoint,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.note,
    required this.cartIds,
  });

  OrderRequestWithCartParam copyWith({
    int? addressId,
    String? systemVoucherCode,
    String? shopVoucherCode,
    bool? useLoyaltyPoint,
    PaymentType? paymentMethod,
    String? shippingMethod,
    String? note,
    List<String>? cartIds,
  }) {
    return OrderRequestWithCartParam(
      addressId: addressId ?? this.addressId,
      systemVoucherCode: systemVoucherCode ?? this.systemVoucherCode,
      shopVoucherCode: shopVoucherCode ?? this.shopVoucherCode,
      useLoyaltyPoint: useLoyaltyPoint ?? this.useLoyaltyPoint,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      note: note ?? this.note,
      cartIds: cartIds ?? this.cartIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressId': addressId,
      'systemVoucherCode': systemVoucherCode,
      'shopVoucherCode': shopVoucherCode,
      'useLoyaltyPoint': useLoyaltyPoint,
      'paymentMethod': paymentMethod.name,
      'shippingMethod': shippingMethod,
      'note': note,
      'cartIds': cartIds,
    };
  }

  // factory PlaceOrderWithCartParam.fromMap(Map<String, dynamic> map) {
  //   return PlaceOrderWithCartParam(
  //     addressId: map['addressId'] as int,
  //     systemVoucherCode: map['systemVoucherCode'] != null ? map['systemVoucherCode'] as String : null,
  //     shopVoucherCode: map['shopVoucherCode'] != null ? map['shopVoucherCode'] as String : null,
  //     // useLoyaltyPoint: map['useLoyaltyPoint'] != null ? map['useLoyaltyPoint'] as bool? : null,
  //     useLoyaltyPoint:  map['useLoyaltyPoint'] as bool,
  //     paymentMethod: map['paymentMethod'] as String,
  //     shippingMethod: map['shippingMethod'] as String,
  //     note: map['note'] as String,
  //     cartIds: List<String>.from((map['cartIds'] as List<dynamic>)),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory PlaceOrderWithCartParam.fromJson(String source) =>
  //     PlaceOrderWithCartParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant OrderRequestWithCartParam other) {
    if (identical(this, other)) return true;

    return other.addressId == addressId &&
        other.systemVoucherCode == systemVoucherCode &&
        other.shopVoucherCode == shopVoucherCode &&
        other.useLoyaltyPoint == useLoyaltyPoint &&
        other.paymentMethod == paymentMethod &&
        other.shippingMethod == shippingMethod &&
        other.note == note &&
        listEquals(other.cartIds, cartIds);
  }

  @override
  int get hashCode {
    return addressId.hashCode ^
        systemVoucherCode.hashCode ^
        shopVoucherCode.hashCode ^
        useLoyaltyPoint.hashCode ^
        paymentMethod.hashCode ^
        shippingMethod.hashCode ^
        note.hashCode ^
        cartIds.hashCode;
  }
}
