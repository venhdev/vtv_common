import 'package:equatable/equatable.dart';

class AddOrUpdateAddressParam extends Equatable {
  final int? addressId;
  final String? wardCode;

  final String? provinceName;
  final String? districtName;
  final String? wardName;

  final String? fullAddress;
  final String? fullName;
  final String? phone;

  const AddOrUpdateAddressParam({
    this.addressId,
    this.provinceName,
    this.districtName,
    this.wardName,
    this.fullAddress,
    this.fullName,
    this.phone,
    this.wardCode,
  });

  factory AddOrUpdateAddressParam.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateAddressParam(
      addressId: json['addressId'] as int?,
      provinceName: json['provinceName'] as String?,
      districtName: json['districtName'] as String?,
      wardName: json['wardName'] as String?,
      fullAddress: json['fullAddress'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      wardCode: json['wardCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'addressId': addressId,
        'wardCode': wardCode,
        //
        'provinceName': provinceName,
        'districtName': districtName,
        'wardName': wardName,
        //
        'fullAddress': fullAddress,
        'fullName': fullName,
        'phone': phone,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      addressId,
      provinceName,
      districtName,
      wardName,
      fullAddress,
      fullName,
      phone,
      wardCode,
    ];
  }
}
