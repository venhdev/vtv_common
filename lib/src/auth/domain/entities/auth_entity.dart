import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'user_info_entity.dart';

class AuthEntity<T> extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserInfoEntity userInfo;

  //# dynamic data for more flexible
  // final T? data;
  // final T Function(String json)? decodeData;
  // final String Function(dynamic source)? encodeData;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userInfo,
    // this.data,
    // this.decodeData,
    // this.encodeData,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerDTO': userInfo.toMap(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      // if (encodeData != null) 'data': encodeData!(data),
    };
  }

  // factory AuthEntity.fromMap(Map<String, dynamic> map, {T Function(String json)? decodeData}) {
  factory AuthEntity.fromMap(Map<String, dynamic> map) {
    return AuthEntity(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      userInfo: UserInfoEntity.fromMap(map['customerDTO'] as Map<String, dynamic>),
      // data: decodeData != null ? decodeData(map['data'] as String) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthEntity.fromJson(String source) => AuthEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [accessToken, refreshToken, userInfo];

  AuthEntity copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoEntity? userInfo,
    // T? data,
  }) {
    return AuthEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
      // data: data ?? this.data,
    );
  }
}
