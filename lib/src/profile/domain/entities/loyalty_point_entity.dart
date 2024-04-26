// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../core/constants/types.dart';

class LoyaltyPointEntity extends Equatable {
  final int loyaltyPointId;
  final int totalPoint;
  final Status status;
  final String username;
  final DateTime updateAt;

  const LoyaltyPointEntity({
    required this.loyaltyPointId,
    required this.totalPoint,
    required this.status,
    required this.username,
    required this.updateAt,
  });

  @override
  List<Object> get props {
    return [
      loyaltyPointId,
      totalPoint,
      status,
      username,
      updateAt,
    ];
  }

  LoyaltyPointEntity copyWith({
    int? loyaltyPointId,
    int? totalPoint,
    Status? status,
    String? username,
    DateTime? updateAt,
  }) {
    return LoyaltyPointEntity(
      loyaltyPointId: loyaltyPointId ?? this.loyaltyPointId,
      totalPoint: totalPoint ?? this.totalPoint,
      status: status ?? this.status,
      username: username ?? this.username,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loyaltyPointId': loyaltyPointId,
      'totalPoint': totalPoint,
      'status': status,
      'username': username,
      'updateAt': updateAt.toIso8601String(),
    };
  }

  factory LoyaltyPointEntity.fromMap(Map<String, dynamic> map) {
    return LoyaltyPointEntity(
      loyaltyPointId: map['loyaltyPointId'] as int,
      totalPoint: map['totalPoint'] as int,
      status: Status.values.firstWhere((element) => element.name == (map['status'] as String)),
      username: map['username'] as String,
      updateAt: DateTime.parse(map['updateAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoyaltyPointEntity.fromJson(String source) =>
      LoyaltyPointEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
