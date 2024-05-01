import 'package:flutter/material.dart';

import '../../../core/constants/types.dart';
import '../../../core/helpers.dart';
import '../../../shop/presentation/components/shop_info.dart';
import '../../domain/entities/order_entity.dart';
import 'order_item.dart';
import 'order_status_badge.dart';

class OrderPurchaseItem extends StatelessWidget {
  // factory OrderPurchaseItem.customer({
  //   required OrderEntity order,
  //   required VoidCallback? onPressed, // nav to [OrderDetailPage]
  //   required VoidCallback? onReceivedPressed, // customer confirm received order
  //   required Widget buildWhenCompleted, // this will be review button
  //   VoidCallback? onShopPressed, // maybe nav to [ShopPage]
  // }) =>
  //     OrderPurchaseItem(
  //       order: order,
  //       isCustomer: true,
  //       onPressed: onPressed,
  //       onReceivedPressed: onReceivedPressed,
  //       buildWhenCompleted: buildWhenCompleted,
  //       onShopPressed: onShopPressed,
  //     );
  // factory OrderPurchaseItem.vendor({
  //   required OrderEntity order,
  //   required VoidCallback? onPressed, // nav to [OrderDetailPage]
  //   required VoidCallback? onAccepted, // vendor accept order
  //   required VoidCallback? onWaitingForShipping, // vendor ship order
  //   VoidCallback? onShopPressed, // maybe nav to [ShopPage]
  // }) =>
  //     OrderPurchaseItem(
  //       order: order,
  //       isCustomer: false,
  //       onPressed: onPressed,
  //       onShopPressed: onShopPressed,
  //       onAcceptedPressed: onAccepted,
  //       onWaitingForShippingPressed: onWaitingForShipping,
  //     );

  const OrderPurchaseItem({
    super.key,
    required this.order,
    this.onPressed,
    this.onShopPressed,
    this.showShopInfo = true,
    this.actionBuilder,
    // this.onReceivedPressed,
    // this.onAcceptedPressed,
    // this.onWaitingForShippingPressed,
    // this.buildWhenCompleted,
  });

  final OrderEntity order;
  final VoidCallback? onPressed;
  final bool showShopInfo;

  // // Vendor required
  // // vendor accept order (status PENDING => PROCESSING) means vendor start to prepare order
  // final VoidCallback? onAcceptedPressed;
  // // vendor ship order (status PROCESSING => SHIPPING) means vendor start to ship order
  // final VoidCallback? onWaitingForShippingPressed;

  // // Customer required
  // final VoidCallback? onReceivedPressed;

  // build base on order status

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

            //# order status = DELIVERED show button to confirm received
            // if (isCustomer) ...[
            //   if (order.status == OrderStatus.DELIVERED)
            //     OrderPurchaseItemAction(
            //       label: 'Bạn đã nhận được hàng chưa?',
            //       buttonLabel: 'Đã nhận',
            //       onPressed: onReceivedPressed,
            //     ),
            // ] else ...[
            //   if (order.status == OrderStatus.PENDING)
            //     OrderPurchaseItemAction(
            //       label: 'Xác nhận đơn hàng này?',
            //       buttonLabel: 'Xác nhận',
            //       onPressed: onAcceptedPressed,
            //       backgroundColor: Colors.blue.shade100,
            //       buttonColor: Colors.blue.shade200,
            //     ),
            //   if (order.status == OrderStatus.PROCESSING)
            //     OrderPurchaseItemAction(
            //       label: 'Đơn hàng đã chuẩn bị xong?',
            //       buttonLabel: 'Chờ giao hàng',
            //       onPressed: onWaitingForShippingPressed,
            //       backgroundColor: Colors.orange.shade100,
            //       buttonColor: Colors.orange.shade400,
            //     ),
            // ],

            // if (order.status == OrderStatus.COMPLETED && buildWhenCompleted != null) buildWhenCompleted!,
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
  });

  final String label;
  final String buttonLabel;

  final VoidCallback? onPressed;

  final Color? backgroundColor;
  final Color? buttonColor;

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
          // TODO test row 2 btn
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: buttonColor ?? Colors.green.shade400,
            ),
            onPressed: onPressed,
            child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
