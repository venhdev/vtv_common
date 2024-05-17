import 'package:flutter/material.dart';
import 'package:vtv_common/src/core/presentation/components/custom_widgets.dart';

import '../../../core/constants/typedef.dart';
import '../../../core/utils.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/wallet_entity.dart';

class TransactionHistory extends StatelessWidget {
  // AppBar(title: const Text('Lịch sử điểm thưởng'))
  // static const routeName = 'transaction-history';
  // static const path = '/user/transaction-history';

  const TransactionHistory({
    super.key,
    required this.dataCallback,
  });

  final FRespData<WalletEntity> dataCallback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataCallback,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final resultEither = snapshot.data!;
          return resultEither.fold(
            (error) => MessageScreen.error(error.message),
            (ok) => Column(
              children: [
                // total balance
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Số dư hiện tại'),
                      Text(
                        StringUtils.formatCurrency(ok.data!.balance),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mô tả'),
                      Text('Biến động số dư'),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: ok.data!.transactions.length,
                    itemBuilder: (context, index) => TransactionHistoryItem(
                      transaction: ok.data!.transactions[index],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class TransactionHistoryItem extends StatelessWidget {
  const TransactionHistoryItem({super.key, required this.transaction});
  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: ListTile(
        style: ListTileStyle.list,
        title: Text(getTransactionTypeName(transaction.type)),
        subtitle: Text(
            StringUtils.convertDateTimeToString(
              transaction.createAt,
              pattern: 'dd/MM/yyyy hh:mm aa',
            ),
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Text(
          transaction.money.isNegative ? transaction.money.toString() : '+${transaction.money}',
          style: TextStyle(
            color: transaction.money.isNegative ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

String getTransactionTypeName(String? type) {
  switch (type) {
    case 'REFUND':
      return 'Hoàn tiền';
    case 'PAYMENT_VNPAY':
      return 'Thanh toán VNPAY';
    case 'PAYMENT_WALLET':
      return 'Thanh toán ví VTV';
    default:
      return type ?? 'Khác';
  }
}
