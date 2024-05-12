// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'transaction_entity.dart';

class WalletEntity {
  final int walletId;
  final int balance;
  final String status;
  final DateTime updateAt;
  final List<TransactionEntity> transactions;

  WalletEntity({
    required this.walletId,
    required this.balance,
    required this.status,
    required this.updateAt,
    required this.transactions,
  });

  WalletEntity copyWith({
    int? walletId,
    int? balance,
    String? status,
    DateTime? updateAt,
    List<TransactionEntity>? transactions,
  }) {
    return WalletEntity(
      walletId: walletId ?? this.walletId,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      updateAt: updateAt ?? this.updateAt,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'walletId': walletId,
      'balance': balance,
      'status': status,
      'updateAt': updateAt.toIso8601String(),
      'transactionDTOs': transactions.map((x) => x.toMap()).toList(),
    };
  }

  factory WalletEntity.fromMap(Map<String, dynamic> map) {
    return WalletEntity(
      walletId: map['walletId'] as int,
      balance: map['balance'] as int,
      status: map['status'] as String,
      updateAt: DateTime.parse(map['updateAt'] as String),
      transactions: List<TransactionEntity>.from(
        (map['transactionDTOs'] as List).map<TransactionEntity>(
          (x) => TransactionEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletEntity.fromJson(String source) => WalletEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WalletEntity(walletId: $walletId, balance: $balance, status: $status, updateAt: $updateAt, transactions: $transactions)';
  }

  @override
  bool operator ==(covariant WalletEntity other) {
    if (identical(this, other)) return true;

    return other.walletId == walletId &&
        other.balance == balance &&
        other.status == status &&
        other.updateAt == updateAt &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode {
    return walletId.hashCode ^ balance.hashCode ^ status.hashCode ^ updateAt.hashCode ^ transactions.hashCode;
  }
}
