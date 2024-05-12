import 'package:flutter/material.dart';

import '../../../../shop/presentation/components/shop_info.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/order_item_entity.dart';
import '../order_item.dart';
import '../../../../core/presentation/components/wrapper.dart';
import 'order_section_shop_voucher.dart';

class OrderSectionShopItems extends StatelessWidget {
  /// use in [CheckoutPage] to show:
  /// - shop info
  /// - list of items
  /// - shop voucher picker
  const OrderSectionShopItems({
    super.key,
    required this.order,
    this.shopVoucherCode,
    this.onShopVoucherPressed,
    this.onItemPressed,
    this.hideShopVoucherCode = false,
  });

  final OrderEntity order;
  // final ValueChanged<String> onShopVoucherChanged;
  final VoidCallback? onShopVoucherPressed;
  final String? shopVoucherCode;

  // style
  /// set true when display in [OrderDetailPage]
  final bool hideShopVoucherCode;

  // optional
  final ValueChanged<OrderItemEntity>? onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: Column(
        children: [
          //# shop info
          ShopInfo(
            shopId: order.shop.shopId,
            shopName: order.shop.name,
            shopAvatar: order.shop.avatar,
            hideAllButton: true,
          ),

          //# list of items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.orderItems.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: onItemPressed != null ? () => onItemPressed!(order.orderItems[index]) : null,
                child: OrderItem(order.orderItems[index]),
              );
            },
          ),

          //# shop voucher picker
          if (!hideShopVoucherCode)
            OrderSectionShopVoucher(
              shopVoucherCode: shopVoucherCode,
              // onChanged: onShopVoucherChanged,
              onPressed: onShopVoucherPressed,
              shopId: order.shop.shopId,
            ),
        ],
      ),
    );
  }
}
