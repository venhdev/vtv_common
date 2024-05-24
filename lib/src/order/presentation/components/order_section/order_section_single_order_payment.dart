import 'package:flutter/material.dart';

import '../../../../core/utils.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../core/presentation/components/wrapper.dart';
import 'payment_summary_item.dart';

class OrderSectionSingleOrderPayment extends StatelessWidget {
  const OrderSectionSingleOrderPayment({
    super.key,
    required OrderEntity order,
  }) : _order = order;

  final OrderEntity _order;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tổng cộng',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          PaymentSummaryItem(
            label: 'Tổng tiền hàng:',
            price: ConversionUtils.formatCurrency(_order.totalPrice),
          ),
          PaymentSummaryItem(
            label: 'Phí vận chuyển:',
            price: ConversionUtils.formatCurrency(_order.shippingFee),
          ),

          // if (_placeOrderWithCartParam.systemVoucherCode != null)
          if (_order.discountSystem != 0)
            PaymentSummaryItem(
              label: 'Giảm giá hệ thống:',
              price: ConversionUtils.formatCurrency(_order.discountSystem),
            ),
          // if (_placeOrderWithCartParam.shopVoucherCode != null)
          if (_order.discountShop != 0)
            PaymentSummaryItem(
              label: 'Giảm giá cửa hàng:',
              price: ConversionUtils.formatCurrency(_order.discountShop),
            ),

          //? not null means using loyalty point
          if (_order.loyaltyPointHistory != null) ...[
            //? maybe negative point >> no need to add '-' sign
            PaymentSummaryItem(
              label: 'Sử dụng điểm tích lũy:',
              price: ConversionUtils.formatCurrency(_order.loyaltyPointHistory!.point),
            ),
          ],

          // total price,
          const Divider(thickness: 0.2, height: 4),
          PaymentSummaryItem(
            label: 'Tổng số tiền:',
            price: ConversionUtils.formatCurrency(_order.paymentTotal),
            priceStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
