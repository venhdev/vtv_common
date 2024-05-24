import 'package:flutter/material.dart';

import '../../../../core/utils.dart';
import '../../../domain/entities/multiple_order_resp.dart';
import '../../../../core/presentation/components/wrapper.dart';
import 'payment_summary_item.dart';

class OrderSectionMultiOrderPayment extends StatelessWidget {
  const OrderSectionMultiOrderPayment({
    super.key,
    required MultipleOrderResp multiOrderResp,
  }) : _multiOrderResp = multiOrderResp;

  final MultipleOrderResp _multiOrderResp;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      label: WrapperLabel(
        icon: Icons.payments,
        labelText: 'Chi tiết thanh toán (${_multiOrderResp.totalQuantity} sản phẩm)',
        iconColor: Colors.green,
      ),
      child: Column(
        children: [
          PaymentSummaryItem(
            label: 'Tổng tiền hàng:',
            price: ConversionUtils.formatCurrency(_multiOrderResp.totalPrice),
          ),
          PaymentSummaryItem(
            label: 'Tổng tiền phí vận chuyển:',
            price: ConversionUtils.formatCurrency(_multiOrderResp.totalShippingFee),
          ),
          if (_multiOrderResp.totalLoyaltyPoint != null && _multiOrderResp.totalLoyaltyPoint != 0)
            PaymentSummaryItem(
              label: 'Sử dụng điểm tích lũy:',
              price: ConversionUtils.formatCurrency(_multiOrderResp.totalLoyaltyPoint!),
            ),
          if (_multiOrderResp.discountShop != 0)
            PaymentSummaryItem(
              label: 'Tổng giảm giá từ cửa hàng:',
              price: ConversionUtils.formatCurrency(_multiOrderResp.discountShop),
            ),
          if (_multiOrderResp.discountSystem != 0)
            PaymentSummaryItem(
              label: 'Tổng giảm giá từ hệ thống:',
              price: ConversionUtils.formatCurrency(_multiOrderResp.discountSystem),
            ),
          PaymentSummaryItem(
            label: 'Tổng thanh toán:',
            price: ConversionUtils.formatCurrency(_multiOrderResp.totalPayment),
            priceStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
