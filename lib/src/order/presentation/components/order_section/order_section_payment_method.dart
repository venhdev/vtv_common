import 'package:flutter/material.dart';

import '../../../../core/constants/types.dart';
import '../../../../core/presentation/components/options_dialog.dart';
import '../../../../core/utils.dart';
import '../../../../core/presentation/components/wrapper.dart';

const _hintStyle = TextStyle(color: Colors.grey, fontSize: 12);

class OrderSectionPaymentMethod extends StatelessWidget {
  const OrderSectionPaymentMethod({
    super.key,
    required this.paymentMethod,
    this.balance,
    this.totalPayment,
    this.onChanged,
    this.disabled = false,
    this.paid = false,
    this.suffixLabelText,
  });

  final PaymentType paymentMethod;
  final int? balance;
  final int? totalPayment;
  final ValueChanged<PaymentType>? onChanged;

  // style
  final bool disabled; // --whether this is used in order detail page just for displaying
  final bool paid; // --whether this order status is UNPAID
  final String? suffixLabelText;

  Widget paymentHint(PaymentType method) {
    if (!PaymentType.values.contains(method)) return const SizedBox.shrink();

    return Text(
      StringUtils.getPaymentNameByPaymentTypes(method),
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  Widget paymentInfo(PaymentType method) {
    if (!PaymentType.values.contains(method)) return const SizedBox.shrink();

    if (disabled && method != PaymentType.COD) {
      // return Text(paid ? 'Đã thanh toán' : 'Chưa thanh toán', style: _hintStyle);
      return const SizedBox.shrink();
    }

    switch (method) {
      case PaymentType.Wallet:
        return Text(
          ' (số dư ví: ${ConversionUtils.formatCurrency(balance!)})',
          style: _hintStyle,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  IconData paymentIcon(PaymentType method) {
    switch (method) {
      case PaymentType.COD:
        return Icons.money;
      case PaymentType.Wallet:
        return Icons.account_balance_wallet;
      case PaymentType.VNPay:
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  Color paymentColor(PaymentType method) {
    switch (method) {
      case PaymentType.COD:
        return Colors.green;
      case PaymentType.Wallet:
        return Colors.blue;
      case PaymentType.VNPay:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void selectPaymentMethod(BuildContext context) async {
    bool walletNotEnough = balance! < totalPayment!;

    final method = await showDialog<PaymentType>(
      context: context,
      builder: (context) => OptionsDialog<PaymentType>(
        title: 'Chọn phương thức thanh toán',
        options: PaymentType.values.map((e) => e).toList(),
        disableOptions: [
          if (walletNotEnough) PaymentType.Wallet,
        ],
        optionBuilder: (context, value, disabled) {
          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: (disabled) ? Colors.red.shade50 : Colors.transparent,
              border: Border.all(color: value == paymentMethod ? Colors.green : Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(paymentIcon(value), color: paymentColor(value)),
                    const SizedBox(width: 2),
                    Text(StringUtils.getPaymentNameByPaymentTypes(value)),
                    const SizedBox(width: 2),
                  ],
                ),
                paymentInfo(value),
              ],
            ),
          );
        },
      ),
    );

    if (method != null && onChanged != null) {
      onChanged!(method);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(disabled || (balance != null && totalPayment != null),
        'balance and totalPayment must be provided when disabled is false. current balance: $balance, totalPayment: $totalPayment, disabled: $disabled');

    return Wrapper(
      disabled: disabled,
      backgroundColor: Colors.white,
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      onPressed: () => selectPaymentMethod(context),
      label: const WrapperLabel(
        icon: Icons.payment,
        labelText: 'Phương thức thanh toán',
        iconColor: Colors.redAccent,
      ),
      suffixLabel: Row(
        children: [
          Row(children: [
            Text(paymentMethod.name),
            const SizedBox(width: 2),
            Icon(paymentIcon(paymentMethod), size: 20, color: paymentColor(paymentMethod)),
          ]),
          if (!disabled) const Icon(Icons.arrow_forward_ios_outlined, size: 12, color: Colors.grey),
        ],
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            paymentInfo(paymentMethod),
            paymentHint(paymentMethod),
          ],
        ),
      ),
    );
  }
}
