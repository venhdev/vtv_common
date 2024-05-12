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
    this.onChanged,
    this.disabled = false,
    this.paid = false,
    this.suffixLabelText,
  });

  final PaymentTypes paymentMethod;
  final int? balance;
  final ValueChanged<PaymentTypes>? onChanged;

  // style
  final bool disabled; // --whether this is used in order detail page
  final bool paid; // --whether this order status is UNPAID
  final String? suffixLabelText;

  Widget paymentHint(PaymentTypes method) {
    if (!PaymentTypes.values.contains(method)) return const SizedBox.shrink();

    return Text(
      StringUtils.getPaymentNameByPaymentTypes(method),
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  Widget paymentInfo(PaymentTypes method) {
    if (!PaymentTypes.values.contains(method)) return const SizedBox.shrink();

    if (disabled && method != PaymentTypes.COD) {
      return Text(paid ? 'Đã thanh toán' : 'Chưa thanh toán', style: _hintStyle);
    }

    switch (method) {
      case PaymentTypes.Wallet:
        return Text(
          ' (số dư ví: ${StringUtils.formatCurrency(balance!)})',
          style: _hintStyle,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  IconData paymentIcon(PaymentTypes method) {
    switch (method) {
      case PaymentTypes.COD:
        return Icons.money;
      case PaymentTypes.Wallet:
        return Icons.account_balance_wallet;
      case PaymentTypes.VNPay:
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  Color paymentColor(PaymentTypes method) {
    switch (method) {
      case PaymentTypes.COD:
        return Colors.green;
      case PaymentTypes.Wallet:
        return Colors.blue;
      case PaymentTypes.VNPay:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      disabled: disabled,
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      onPressed: () async {
        final method = await showDialog<PaymentTypes>(
          context: context,
          builder: (context) => OptionsDialog<PaymentTypes>(
            title: 'Phương thức thanh toán',
            options: PaymentTypes.values.map((e) => e).toList(),
            optionBuilder: (context, value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(paymentIcon(value), color: paymentColor(value)),
                        const SizedBox(width: 2),
                        Text(StringUtils.getPaymentNameByPaymentTypes(value)),
                        const SizedBox(width: 2),
                      ],
                    ),
                    if (value == paymentMethod)
                      const Expanded(
                        child: Text(
                          '(Đang dùng)',
                          style: _hintStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );

        if (method != null && onChanged != null) {
          onChanged!(method);
        }
      },
      label: const WrapperLabel(
        icon: Icons.payment,
        labelText: 'Phương thức thanh toán',
        iconColor: Colors.redAccent,
      ),
      suffixLabel: Row(
        children: [
          Row(children: [
            // Text(suffixLabelText ?? '(Chọn phương thức khác)',
            //     style: const TextStyle(fontSize: 12, color: Colors.grey)),
            // const SizedBox(width: 2),
            // paymentHintByMethod(paymentMethod),
            Text(paymentMethod.name),
            const SizedBox(width: 2),
            Icon(paymentIcon(paymentMethod), size: 20, color: paymentColor(paymentMethod)),
          ]),
          const Icon(Icons.arrow_forward_ios_outlined, size: 12, color: Colors.grey),
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
