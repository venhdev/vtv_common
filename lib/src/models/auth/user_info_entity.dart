import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../core/constants/types.dart';

class UserInfoEntity extends Equatable {
  final int? customerId;
  final String? username;
  final String? fullName;
  final bool? gender;
  final String? email;
  final DateTime? birthday;
  final Status? status;
  final List<Role>? roles;

  const UserInfoEntity({
    required this.customerId,
    required this.username,
    required this.fullName,
    required this.gender,
    required this.email,
    required this.birthday,
    required this.status,
    required this.roles,
  });

  UserInfoEntity copyWith({
    int? customerId,
    String? username,
    String? fullName,
    bool? gender,
    String? email,
    DateTime? birthday,
    Status? status,
    List<Role>? roles,
  }) {
    return UserInfoEntity(
      customerId: customerId ?? this.customerId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      status: status ?? this.status,
      roles: roles ?? this.roles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (customerId != null) 'customerId': customerId,
      if (username != null) 'username': username,
      if (fullName != null) 'fullName': fullName,
      if (gender != null) 'gender': gender,
      if (email != null) 'email': email,
      if (birthday != null) 'birthday': birthday!.toIso8601String(),
      if (status != null) 'status': status!.name,
      if (roles != null) 'roles': roles!.map((e) => e.name).toList(),
    };
  }

  factory UserInfoEntity.fromMap(Map<String, dynamic> map) {
    return UserInfoEntity(
      customerId: map['customerId'] as int?,
      username: map['username'] as String?,
      fullName: map['fullName'] as String?,
      gender: map['gender'] as bool?,
      email: map['email'] as String?,
      birthday: map['birthday'] != null ? DateTime.parse(map['birthday'] as String) : null,
      status: Status.values.firstWhere((status) => status.name == map['status'] as String),
      roles: (map['roles'] as List<dynamic>?)
          ?.map(
            (role) => Role.values.firstWhere((r) => r.name == role),
          )
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfoEntity.fromJson(String source) => UserInfoEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      customerId,
      username,
      fullName,
      gender,
      email,
      birthday,
      status,
      roles,
    ];
  }
}
