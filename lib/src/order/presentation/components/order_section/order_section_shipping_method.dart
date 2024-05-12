import 'package:flutter/material.dart';

import '../../../../core/utils.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../core/presentation/components/wrapper.dart';

class OrderSectionShippingMethod extends StatelessWidget {
  const OrderSectionShippingMethod({
    super.key,
    required OrderEntity order,
    this.showShippingFee = true,
  }) : _order = order;

  final OrderEntity _order;
  final bool showShippingFee;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      label: const WrapperLabel(
        icon: Icons.local_shipping,
        labelText: 'Phương thức vận chuyển',
        iconColor: Colors.blue,
      ),
      suffixLabel: Text(_order.shippingMethod),
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: showShippingFee
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Phí vận chuyển:',
                ),
                Text(StringUtils.formatCurrency(_order.shippingFee)),
              ],
            )
          : null,
    );
  }
}
