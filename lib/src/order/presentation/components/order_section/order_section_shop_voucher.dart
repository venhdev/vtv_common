import 'package:flutter/material.dart';

import '../../../../core/presentation/components/wrapper.dart';

class OrderSectionShopVoucher extends StatelessWidget {
  const OrderSectionShopVoucher({
    super.key,
    required this.shopId,
    required this.onPressed,
    required this.shopVoucherCode,
  });

  final int shopId;
  final String? shopVoucherCode;
  // final ValueChanged<String> onChanged;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      useBoxShadow: false,
      onPressed: onPressed,
      label: const WrapperLabel(
        icon: Icons.local_offer,
        labelText: 'Mã giảm giá cửa hàng',
        iconColor: Colors.green,
      ),
      suffixLabel: Text(
        shopVoucherCode ?? 'Chưa chọn mã giảm giá',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: shopVoucherCode == null ? Colors.grey : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      // onPressed: () async {
      //   // show dialog to choose voucher
      //   final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
      //     builder: (context) {
      //       return VoucherPage(
      //         returnValue: true,
      //         future: sl<VoucherRepository>().listOnShop(shopId),
      //       );
      //     },
      //   ));

      //   if (voucher != null) {
      //     if (shopVoucherCode != voucher.code) {
      //       onChanged(voucher.code);
      //     }
      //   }
      // },
    );
  }
}
