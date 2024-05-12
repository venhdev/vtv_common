import 'dart:convert';

class TransactionEntity {
  final String transactionId;
  final int walletId;
  final String orderId;
  final int money;
  final String type;
  final String status;
  final DateTime createAt;

  TransactionEntity({
    required this.transactionId,
    required this.walletId,
    required this.orderId,
    required this.money,
    required this.type,
    required this.status,
    required this.createAt,
  });

  TransactionEntity copyWith({
    String? transactionId,
    int? walletId,
    String? orderId,
    int? money,
    String? type,
    String? status,
    DateTime? createAt,
  }) {
    return TransactionEntity(
      transactionId: transactionId ?? this.transactionId,
      walletId: walletId ?? this.walletId,
      orderId: orderId ?? this.orderId,
      money: money ?? this.money,
      type: type ?? this.type,
      status: status ?? this.status,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'walletId': walletId,
      'orderId': orderId,
      'money': money,
      'type': type,
      'status': status,
      'createAt': createAt.toIso8601String(),
    };
  }

  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      transactionId: map['transactionId'] as String,
      walletId: map['walletId'] as int,
      orderId: map['orderId'] as String,
      money: map['money'] as int,
      type: map['type'] as String,
      status: map['status'] as String,
      createAt: DateTime.parse(map['createAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionEntity.fromJson(String source) =>
      TransactionEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionEntity(transactionId: $transactionId, walletId: $walletId, orderId: $orderId, money: $money, type: $type, status: $status, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant TransactionEntity other) {
    if (identical(this, other)) return true;

    return other.transactionId == transactionId &&
        other.walletId == walletId &&
        other.orderId == orderId &&
        other.money == money &&
        other.type == type &&
        other.status == status &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return transactionId.hashCode ^
        walletId.hashCode ^
        orderId.hashCode ^
        money.hashCode ^
        type.hashCode ^
        status.hashCode ^
        createAt.hashCode;
  }
}
