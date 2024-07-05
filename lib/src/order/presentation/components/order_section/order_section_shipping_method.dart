import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../../../domain/entities/shipping_entity.dart';

class OrderSectionShippingMethod extends StatelessWidget {
  const OrderSectionShippingMethod({
    super.key,
    required String orderShippingMethod,
    required int orderShippingFee,
    DateTime? estimatedDeliveryDate,
    this.selectable = false,
    this.onSelected,
    this.futureData,
  })  : _orderShippingMethod = orderShippingMethod,
        _estimatedDeliveryDate = estimatedDeliveryDate,
        _orderShippingFee = orderShippingFee;

  final String _orderShippingMethod;
  final int? _orderShippingFee;
  final DateTime? _estimatedDeliveryDate;

  final bool selectable;
  final ValueCallback<ShippingEntity>? onSelected;
  final FRespData<List<ShippingEntity>>? futureData;

  void selectTransportMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn phương thức vận chuyển'),
          content: FutureBuilder(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.fold(
                  (error) => MessageScreen.error(error.message),
                  (ok) {
                    if (ok.data!.isEmpty) {
                      return const MessageScreen(message: 'Không tìm thấy đơn vị vận chuyển nào!');
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final transport in ok.data!)
                            ListTile(
                              tileColor: transport.transportProviderShortName == _orderShippingMethod
                                  ? Colors.grey.shade200
                                  : null,
                              leading: const Icon(Icons.local_shipping),
                              title: Text(transport.transportProviderFullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dự kiến giao ngày: ${ConversionUtils.convertDateTimeToString(transport.estimatedDeliveryTime)}',
                                  ),
                                  Text('Phí vẩn chuyển: ${ConversionUtils.formatCurrency(transport.shippingCost)}'),
                                ],
                              ),
                              onTap: transport.transportProviderShortName == _orderShippingMethod
                                  ? null
                                  : () {
                                      onSelected?.call(transport);
                                      Navigator.of(context).pop();
                                    },
                            ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return MessageScreen.error(snapshot.error.toString());
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      onPressed: (selectable && futureData != null)
          ? () {
              selectTransportMethodDialog(context);
            }
          : null,
      label: const WrapperLabel(
        icon: Icons.local_shipping,
        labelText: 'Phương thức vận chuyển',
        iconColor: Colors.blue,
      ),
      suffixLabel: Row(
        children: [
          Text(_orderShippingMethod),
          if (selectable) const Icon(Icons.arrow_forward_ios_outlined, size: 12, color: Colors.grey),
        ],
      ),
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: _orderShippingFee != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // estimated delivery date
                if (_estimatedDeliveryDate != null)
                  Text(
                    'Dự kiến ngày giao: ${ConversionUtils.convertDateTimeToString(_estimatedDeliveryDate)}',
                    style: VTVTheme.hintText12,
                  ),
                // shipping fee
                Text(ConversionUtils.formatCurrency(_orderShippingFee)),
              ],
            )
          : null,
    );
  }
}
