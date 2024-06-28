// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
  final int shopId;
  final String name;
  final String address;
  final String provinceName;
  final String districtName;
  final String wardName;
  final String phone;
  final String email;
  final String avatar;
  final String description;
  // final DateTime openTime;
  // final DateTime closeTime;
  final String openTime;
  final String closeTime;
  final String status;
  final int customerId;
  final String wardCode;
  final String shopUsername;

  const ShopEntity({
    required this.shopId,
    required this.name,
    required this.address,
    required this.provinceName,
    required this.districtName,
    required this.wardName,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.description,
    required this.openTime,
    required this.closeTime,
    required this.status,
    required this.customerId,
    required this.wardCode,
    required this.shopUsername,
  });

  String get fullAddress => '$address, $wardName, $districtName, $provinceName';

  @override
  List<Object> get props {
    return [
      shopId,
      name,
      address,
      provinceName,
      districtName,
      wardName,
      phone,
      email,
      avatar,
      description,
      openTime,
      closeTime,
      status,
      customerId,
      wardCode,
      shopUsername,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shopId': shopId,
      'name': name,
      'address': address,
      'provinceName': provinceName,
      'districtName': districtName,
      'wardName': wardName,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'description': description,
      'openTime': openTime,
      'closeTime': closeTime,
      'status': status,
      'customerId': customerId,
      'wardCode': wardCode,
    };
  }

  factory ShopEntity.fromMap(Map<String, dynamic> map) {
    return ShopEntity(
      shopId: map['shopId'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      provinceName: map['provinceName'] as String,
      districtName: map['districtName'] as String,
      wardName: map['wardName'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      description: map['description'] as String,
      openTime: map['openTime'] as String,
      closeTime: map['closeTime'] as String,
      // openTime: DateTime.parse(map['openTime'] as String),
      // closeTime: DateTime.parse(map['closeTime'] as String),
      status: map['status'] as String,
      customerId: map['customerId'] as int,
      wardCode: map['wardCode'] as String,
      shopUsername: map['shopUsername'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopEntity.fromJson(String source) => ShopEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
