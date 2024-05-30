import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../core/constants/types.dart';
import 'user_info_entity.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserInfoEntity userInfo;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userInfo,
  });

  bool get isVendor => userInfo.roles!.contains(Role.VENDOR);
  bool get isDeliver => userInfo.roles!.contains(Role.DELIVER);
  bool get isProvider => userInfo.roles!.contains(Role.PROVIDER);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerDTO': userInfo.toMap(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory AuthEntity.fromMap(Map<String, dynamic> map) {
    return AuthEntity(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      userInfo: UserInfoEntity.fromMap(map['customerDTO'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthEntity.fromJson(String source) => AuthEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [accessToken, refreshToken, userInfo];

  AuthEntity copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoEntity? userInfo,
  }) {
    return AuthEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}
