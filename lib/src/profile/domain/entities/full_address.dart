// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FullAddress extends Equatable {
  final String provinceName;
  final String provinceCode;
  final String districtName;
  final String districtCode;
  final String wardName;
  final String wardCode;
  final String fullAddress;
  
  const FullAddress({
    required this.provinceName,
    required this.provinceCode,
    required this.districtName,
    required this.districtCode,
    required this.wardName,
    required this.wardCode,
    required this.fullAddress,
  });

  @override
  List<Object> get props {
    return [
      provinceName,
      provinceCode,
      districtName,
      districtCode,
      wardName,
      wardCode,
      fullAddress,
    ];
  }

  FullAddress copyWith({
    String? provinceName,
    String? provinceCode,
    String? districtName,
    String? districtCode,
    String? wardName,
    String? wardCode,
    String? fullAddress,
  }) {
    return FullAddress(
      provinceName: provinceName ?? this.provinceName,
      provinceCode: provinceCode ?? this.provinceCode,
      districtName: districtName ?? this.districtName,
      districtCode: districtCode ?? this.districtCode,
      wardName: wardName ?? this.wardName,
      wardCode: wardCode ?? this.wardCode,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'provinceName': provinceName,
      'provinceCode': provinceCode,
      'districtName': districtName,
      'districtCode': districtCode,
      'wardName': wardName,
      'wardCode': wardCode,
      'fullAddress': fullAddress,
    };
  }

  factory FullAddress.fromMap(Map<String, dynamic> map) {
    return FullAddress(
      provinceName: map['provinceName'] as String,
      provinceCode: map['provinceCode'] as String,
      districtName: map['districtName'] as String,
      districtCode: map['districtCode'] as String,
      wardName: map['wardName'] as String,
      wardCode: map['wardCode'] as String,
      fullAddress: map['fullAddress'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FullAddress.fromJson(String source) => FullAddress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
