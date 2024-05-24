import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timelines/timelines.dart';

import '../../../core/constants/types.dart';
import '../../../core/presentation/components/wrapper.dart';
import '../../../core/presentation/pages/qr_view_page.dart';
import '../../../core/utils.dart';
import '../../../profile/presentation/components/address.dart';
import '../../domain/entities/order_detail_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../components/action_button.dart';
import '../components/order_section/order_section.dart';
import '../components/order_status_badge.dart';

// const String _noVoucherMsg = 'Không áp dụng';

class OrderDetailPage extends StatelessWidget {
  // const OrderDetailPage({
  //   super.key,
  //   required this.isVendor,
  //   required this.orderDetail,
  //   this.onPayPressed,
  //   this.onCompleteOrderPressed,
  //   this.onCancelOrderPressed,
  //   this.onRePurchasePressed,
  //   this.customerReviewBtn,
  //   this.onOrderItemPressed,
  //   this.onBack,
  // });

  const OrderDetailPage.customer({
    super.key,
    required this.orderDetail,
    required this.onCompleteOrderPressed,
    required this.onCancelOrderPressed,
    required this.onRePurchasePressed,
    required this.customerReviewBtn,
    required this.onPayPressed,
    this.onOrderItemPressed,
    required this.onBack,
    required this.onRefresh,
  })  : isVendor = false,
        onAcceptCancelPressed = null,
        onAcceptPressed = null,
        onPackedPressed = null;

  const OrderDetailPage.vendor({
    super.key,
    required this.orderDetail,
    this.onOrderItemPressed,
    required this.onBack,
    required this.onRefresh,
    required this.onAcceptCancelPressed,
    required this.onAcceptPressed,
    required this.onPackedPressed,
  })  : isVendor = true,
        onCompleteOrderPressed = null,
        onCancelOrderPressed = null,
        onRePurchasePressed = null,
        customerReviewBtn = null,
        onPayPressed = null;

  // static const String routeName = 'order-detail';
  // static const String path = '/user/purchase/order-detail';

  final OrderDetailEntity orderDetail;
  final void Function(OrderItemEntity orderItem)? onOrderItemPressed;
  final bool isVendor;
  final Future<void> Function() onRefresh;

  //! Vendor required properties
  final Future<void> Function(String orderId)? onAcceptCancelPressed;
  final Future<void> Function(String orderId)? onAcceptPressed;
  final Future<void> Function(String orderId)? onPackedPressed;

  //! Customer required properties
  final Future<void> Function(String orderId)? onCompleteOrderPressed;
  final Future<void> Function(String orderId)? onCancelOrderPressed;
  final Future<void> Function(String orderId)? onPayPressed;
  final Future<void> Function(List<OrderItemEntity> orderItems)? onRePurchasePressed;
  final Widget Function(OrderEntity order)? customerReviewBtn;

  //! Custom (for all role)
  final void Function() onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      bottomSheet: _buildBottomActionByOrderStatus(context, orderDetail.order.status),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //! order status 'mã đơn hàng' + 'ngày đặt hàng' + copy button
                Wrapper(
                  // backgroundColor: Colors.red.shade100,
                  backgroundColor: ColorUtils.getOrderStatusBackgroundColor(orderDetail.order.status, shade: 100),
                  child: Column(
                    children: [
                      // order date + order id
                      _buildOrderInfo(),
                      // status
                      _buildOrderStatus(),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                //# summary info: transport + shipping method + order timeline
                _transportSummary(context),
                const SizedBox(height: 8),

                //! shop info + list of items
                OrderSectionShopItems(
                  order: orderDetail.order,
                  hideShopVoucherCode: true,
                  onItemPressed: onOrderItemPressed,
                ),
                const SizedBox(height: 8),

                //! payment method
                // _buildPaymentMethod(),
                OrderSectionPaymentMethod(
                  disabled: true,
                  paymentMethod: orderDetail.order.paymentMethod,
                  paid: orderDetail.order.status != OrderStatus.UNPAID,
                ),
                const SizedBox(height: 8),

                //! total price
                OrderSectionSingleOrderPayment(order: orderDetail.order),
                // hideVoucherCode: true,

                //! note
                if (orderDetail.order.note?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  OrderSectionNote(note: orderDetail.order.note!, readOnly: true),
                ],

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildOrderInfo() {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            // 'Ngày đặt hàng',
            TextSpan(text: 'Ngày đặt hàng:\n', children: [
              TextSpan(
                text: ConversionUtils.convertDateTimeToString(
                  (orderDetail.order.orderDate),
                  pattern: 'dd-MM-yyyy hh:mm aa',
                ),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ]),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    text: 'Mã đơn hàng: ',
                    style: const TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: orderDetail.order.orderId.toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Icon(Icons.copy),
              IconButton(
                icon: const Icon(Icons.copy),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: orderDetail.order.orderId.toString()));
                  Fluttertoast.showToast(msg: 'Đã sao chép mã đơn hàng');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _transportSummary(BuildContext context) {
    return Wrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Thông tin vận chuyển',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          text: 'Mã vận đơn: ',
                          style: const TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text: orderDetail.transport!.transportId,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //btn copy
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: orderDetail.transport!.transportId));
                        Fluttertoast.showToast(msg: 'Đã sao chép mã vận đơn');
                      },
                    ),
                    // btn show qr code
                    IconButton(
                      icon: const Icon(Icons.qr_code),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return QrViewPage(data: orderDetail.transport!.transportId);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          OrderSectionShippingMethod(order: orderDetail.order, showShippingFee: false),
          const SizedBox(height: 4),
          Address(address: orderDetail.order.address, color: Colors.white, suffixIcon: null),
          Timeline.tileBuilder(
            padding: const EdgeInsets.all(8),
            theme: TimelineThemeData(nodePosition: 0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // reverse: false,
            builder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        ConversionUtils.convertDateTimeToString(
                          orderDetail.transport!.transportHandles[index].createAt,
                          pattern: 'dd-MM-yyyy\nHH:mm',
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '(${orderDetail.transport!.transportHandles[index].transportStatus}) ${orderDetail.transport!.transportHandles[index].messageStatus}',
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: orderDetail.transport!.transportHandles.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Column(
      children: [
        //# order status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trạng thái đơn hàng',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            OrderStatusBadge(status: orderDetail.order.status),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActionByOrderStatus(BuildContext context, OrderStatus status) {
    Widget buildCustomerActionByStatus(BuildContext context, OrderStatus status) {
      switch (status) {
        case OrderStatus.WAITING:
          return ActionButton.back(onBack);
        case OrderStatus.UNPAID:
          return ActionButton.pay(() => onPayPressed!(orderDetail.order.orderId!));
        case OrderStatus.PENDING || OrderStatus.PROCESSING || OrderStatus.PICKUP_PENDING:
          return ActionButton.customerCancelOrder(() => onCancelOrderPressed!(orderDetail.order.orderId!));
        case OrderStatus.COMPLETED:
          return customerReviewBtn!(orderDetail.order);
        case OrderStatus.CANCEL:
          return ActionButton.customerRePurchase(() => onRePurchasePressed!(orderDetail.order.orderItems));
        case OrderStatus.SHIPPING:
          return ActionButton.back(onBack);
        case OrderStatus.DELIVERED:
          return ActionButton.customerCompleteOrder(() => onCompleteOrderPressed!(orderDetail.order.orderId!));

        default:
          return ActionButton.back(onBack);
      }
    }

    Widget buildVendorActionByStatus(BuildContext context, OrderStatus status) {
      assert(isVendor && onAcceptCancelPressed != null && onAcceptPressed != null && onPackedPressed != null);

      switch (status) {
        case OrderStatus.WAITING:
          return ActionButton.vendorAcceptCancelOrder(() => onAcceptCancelPressed!(orderDetail.order.orderId!));
        case OrderStatus.PENDING:
          return ActionButton.vendorAcceptOrder(() => onAcceptPressed!(orderDetail.order.orderId!));
        case OrderStatus.PROCESSING:
          return ActionButton.vendorPackedOrder(() => onPackedPressed!(orderDetail.order.orderId!));

        default:
          return ActionButton.back(onBack);
      }
    }

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: isVendor
          //! Vendor actions
          ? Row(
              children: [
                // //# vendor first half
                // Expanded(child: ActionButton.back(onBack)),
                //# vendor second half
                Expanded(
                  child: buildVendorActionByStatus(context, status),
                ),
              ],
            )
          //! Customer actions
          : Row(
              children: [
                //# first half: chat - rePurchase
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: ActionButton.customerChat(null)),
                      if (status == OrderStatus.COMPLETED)
                        Expanded(
                            flex: 2,
                            child: ActionButton.customerRePurchase(
                                () => onRePurchasePressed!(orderDetail.order.orderItems))),
                      if (status == OrderStatus.UNPAID)
                        Expanded(
                            flex: 2,
                            child: ActionButton.customerCancelOrder(
                                () => onCancelOrderPressed!(orderDetail.order.orderId!))),
                    ],
                  ),
                ),

                //# second half: action by status
                Expanded(
                  child: buildCustomerActionByStatus(context, status),
                ),
              ],
            ),
    );
  }
}
