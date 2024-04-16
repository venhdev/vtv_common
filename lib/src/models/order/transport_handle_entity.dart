// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransportHandleEntity {
  final String transportHandleId;
  final String username;
  final String wardCode;
  final bool handled;
  final String messageStatus;
  final String transportStatus;
  final DateTime createAt;
  final DateTime updateAt;

  TransportHandleEntity({
    required this.transportHandleId,
    required this.username,
    required this.wardCode,
    required this.handled,
    required this.messageStatus,
    required this.transportStatus,
    required this.createAt,
    required this.updateAt,
  });


  TransportHandleEntity copyWith({
    String? transportHandleId,
    String? username,
    String? wardCode,
    bool? handled,
    String? messageStatus,
    String? transportStatus,
    DateTime? createAt,
    DateTime? updateAt,
  }) {
    return TransportHandleEntity(
      transportHandleId: transportHandleId ?? this.transportHandleId,
      username: username ?? this.username,
      wardCode: wardCode ?? this.wardCode,
      handled: handled ?? this.handled,
      messageStatus: messageStatus ?? this.messageStatus,
      transportStatus: transportStatus ?? this.transportStatus,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transportHandleId': transportHandleId,
      'username': username,
      'wardCode': wardCode,
      'handled': handled,
      'messageStatus': messageStatus,
      'transportStatus': transportStatus,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  factory TransportHandleEntity.fromMap(Map<String, dynamic> map) {
    return TransportHandleEntity(
      transportHandleId: map['transportHandleId'] as String,
      username: map['username'] as String,
      wardCode: map['wardCode'] as String,
      handled: map['handled'] as bool,
      messageStatus: map['messageStatus'] as String,
      transportStatus: map['transportStatus'] as String,
      createAt: DateTime.parse(map['createAt'] as String),
      updateAt: DateTime.parse(map['updateAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransportHandleEntity.fromJson(String source) => TransportHandleEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransportHandleEntity(transportHandleId: $transportHandleId, username: $username, wardCode: $wardCode, handled: $handled, messageStatus: $messageStatus, transportStatus: $transportStatus, createAt: $createAt, updateAt: $updateAt)';
  }

  @override
  bool operator ==(covariant TransportHandleEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.transportHandleId == transportHandleId &&
      other.username == username &&
      other.wardCode == wardCode &&
      other.handled == handled &&
      other.messageStatus == messageStatus &&
      other.transportStatus == transportStatus &&
      other.createAt == createAt &&
      other.updateAt == updateAt;
  }

  @override
  int get hashCode {
    return transportHandleId.hashCode ^
      username.hashCode ^
      wardCode.hashCode ^
      handled.hashCode ^
      messageStatus.hashCode ^
      transportStatus.hashCode ^
      createAt.hashCode ^
      updateAt.hashCode;
  }
}
