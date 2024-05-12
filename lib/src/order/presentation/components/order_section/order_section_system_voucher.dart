import 'package:flutter/material.dart';

import '../../../../core/presentation/components/wrapper.dart';

class OrderSectionSystemVoucher extends StatelessWidget {
  const OrderSectionSystemVoucher({
    super.key,
    this.systemVoucherCode,
    required this.onPressed,
  });

  final String? systemVoucherCode;
  // final ValueChanged<String> onChanged;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      onPressed: onPressed,
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      // onPressed: () async {
      //   // show dialog to choose voucher
      //   final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
      //     builder: (context) {
      //       return VoucherPage(
      //         returnValue: true,
      //         future: sl<VoucherRepository>().listOnSystem(),
      //       );
      //     },
      //   ));

      //   if (voucher != null) {
      //     if (systemVoucherCode != voucher.code) {
      //       onChanged(voucher.code);
      //     }
      //     //   _multipleOrderRequestParam.setSystemVoucherCode = voucher.code;
      //     //   handleChangedOrderRequest(_multipleOrderRequestParam);
      //   }
      // },
      margin: EdgeInsets.zero,
      label: const WrapperLabel(
        icon: Icons.card_giftcard,
        labelText: 'Mã giảm giá hệ thống',
        iconColor: Colors.orange,
      ),
      suffixLabel: Text(
        systemVoucherCode ?? 'Chưa chọn mã giảm giá',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: systemVoucherCode == null ? Colors.grey : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
