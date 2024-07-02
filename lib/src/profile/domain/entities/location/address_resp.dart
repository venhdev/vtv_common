// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'district_entity.dart';
import 'province_entity.dart';
import 'ward_entity.dart';

class AddressResp {
  final String administrativeRegionName;
  final ProvinceEntity province;
  final DistrictEntity district;
  final WardEntity ward;

  AddressResp({
    required this.administrativeRegionName,
    required this.province,
    required this.district,
    required this.ward,
  });

  AddressResp copyWith({
    String? status,
    String? message,
    int? code,
    String? administrativeRegionName,
    ProvinceEntity? province,
    DistrictEntity? district,
    WardEntity? ward,
  }) {
    return AddressResp(
      administrativeRegionName: administrativeRegionName ?? this.administrativeRegionName,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'administrativeRegionName': administrativeRegionName,
      'provinceDTO': province.toMap(),
      'districtDTO': district.toMap(),
      'wardDTO': ward.toMap(),
    };
  }

  factory AddressResp.fromMap(Map<String, dynamic> map) {
    return AddressResp(
      administrativeRegionName: map['administrativeRegionName'] as String,
      province: ProvinceEntity.fromMap(map['provinceDTO'] as Map<String, dynamic>),
      district: DistrictEntity.fromMap(map['districtDTO'] as Map<String, dynamic>),
      ward: WardEntity.fromMap(map['wardDTO'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressResp.fromJson(String source) =>
      AddressResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AddressResp other) {
    if (identical(this, other)) return true;

    return other.administrativeRegionName == administrativeRegionName &&
        other.province == province &&
        other.district == district &&
        other.ward == ward;
  }

  @override
  int get hashCode {
    return administrativeRegionName.hashCode ^ province.hashCode ^ district.hashCode ^ ward.hashCode;
  }

  @override
  String toString() {
    return 'FullAddressResp(administrativeRegionName: $administrativeRegionName, provinceDto: $province, districtDto: $district, wardDto: $ward)';
  }
}
