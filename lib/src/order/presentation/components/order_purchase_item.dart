import 'package:flutter/material.dart';

import '../../../core/constants/types.dart';
import '../../../core/helpers.dart';
import '../../../shop/presentation/components/shop_info.dart';
import '../../domain/entities/order_entity.dart';
import 'order_item.dart';
import 'order_status_badge.dart';

class OrderPurchaseItem extends StatelessWidget {
  const OrderPurchaseItem({
    super.key,
    required this.order,
    this.onPressed,
    this.onShopPressed,
    this.showShopInfo = true,
    this.actionBuilder,
  });

  final OrderEntity order;
  final VoidCallback? onPressed;
  final bool showShopInfo;

  //# Widget build base on order status
  final Widget Function(OrderStatus status)? actionBuilder;

  //# Others (optional)
  final VoidCallback? onShopPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            //# shop info + order status
            if (showShopInfo)
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ShopInfo(
                      shopId: order.shop.shopId,
                      shopName: order.shop.name,
                      shopAvatar: order.shop.avatar,
                      onPressed: onShopPressed,
                      // onPressed: () => context.push('${ShopPage.path}/${order.shop.shopId}'),
                    ),
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),

            //# show the first order item
            const SizedBox(height: 8),
            OrderItem(order.orderItems.first),
            if (order.orderItems.length > 1)
              Text(
                '+ ${order.orderItems.length - 1} sản phẩm khác',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
            //# Sum order items + totalPayment
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.orderItems.length} sản phẩm'),
                  Text('Tổng thanh toán: ${StringHelper.formatCurrency(order.paymentTotal)}'),
                ],
              ),
            ),

            //# action button base on order status
            if (actionBuilder != null) ...[
              const SizedBox(height: 8),
              actionBuilder!(order.status),
            ]
          ],
        ),
      ),
    );
  }
}

class OrderPurchaseItemAction extends StatelessWidget {
  const OrderPurchaseItemAction({
    super.key,
    required this.label,
    required this.buttonLabel,
    required this.onPressed,
    this.backgroundColor,
    this.buttonColor,
    this.secondButtonLabel,
    this.secondOnPressed,
    this.secondButtonColor,
  });

  final String label;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final Color? buttonColor;

  final String? secondButtonLabel;
  final VoidCallback? secondOnPressed;
  final Color? secondButtonColor;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.green.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //# first button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: buttonColor ?? Colors.green.shade400,
                ),
                onPressed: onPressed,
                child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              //# second button
              if (secondButtonLabel != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: secondButtonColor ?? Colors.green.shade400,
                  ),
                  onPressed: secondOnPressed,
                  child: Text(secondButtonLabel!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
