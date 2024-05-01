import 'package:flutter/material.dart';

import '../../../core/constants/types.dart';
import '../../../core/helpers.dart';

enum OrderStatusBadgeType { customer, vendor, driver }

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    this.type = OrderStatusBadgeType.customer,
  });

  final OrderStatus status;
  final OrderStatusBadgeType type;

//   WAITING,
//   PENDING,
//   SHIPPING,
//   COMPLETED,
//   CANCELLED,
//   PROCESSING,
//   CANCELED,

  String nameByType(OrderStatusBadgeType type) {
    switch (type) {
      case OrderStatusBadgeType.customer || OrderStatusBadgeType.vendor:
        return StringHelper.getOrderStatusName(status);
      case OrderStatusBadgeType.driver:
        return StringHelper.getOrderStatusNameByDriver(status);
      default:
        return StringHelper.getOrderStatusName(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: ColorHelper.getOrderStatusBackgroundColor(status),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          // StringHelper.getOrderStatusName(status),
          nameByType(type),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
