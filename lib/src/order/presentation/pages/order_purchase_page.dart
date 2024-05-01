import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/components/custom_widgets.dart';
import '../../../core/constants/typedef.dart';
import '../../../core/constants/types.dart';
import '../../../core/helpers.dart';
import '../../domain/entities/multi_order_entity.dart';
import '../../domain/entities/order_detail_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../components/order_purchase_item.dart';
import 'order_detail_page.dart';

class OrderPurchasePage extends StatefulWidget {
  factory OrderPurchasePage.customer({
    required FRespData<MultiOrderEntity> Function(OrderStatus? status) dataCallback,
    required OrderPurchasePageController pageController,
    required void Function(OrderDetailEntity completedOrder) onReceivedCallback,
    required OrderPurchaseItem Function(OrderEntity, void Function(OrderDetailEntity)) customerItemBuilder,
    String appBarTitle = 'Đơn hàng của bạn',
    List<Widget>? actions,
  }) =>
      OrderPurchasePage(
        dataCallback: dataCallback,
        pageController: pageController,
        isCustomer: true,
        appBarTitle: appBarTitle,
        actions: actions,
        customerItemBuilder: customerItemBuilder,
      );

  factory OrderPurchasePage.vendor({
    required FRespData<MultiOrderEntity> Function(OrderStatus? status) dataCallback,
    List<RespData<MultiOrderEntity>>? initialMultiOrders,
    required OrderPurchasePageController pageController,
    required OrderPurchaseItem Function(OrderEntity, void Function()) vendorItemBuilder,
    String appBarTitle = 'Đơn hàng của bạn',
    List<Widget>? actions,
  }) =>
      OrderPurchasePage(
        dataCallback: dataCallback,
        initialMultiOrders: initialMultiOrders,
        pageController: pageController,
        isCustomer: false,
        appBarTitle: appBarTitle,
        actions: actions,
        vendorItemBuilder: vendorItemBuilder,
      );

  const OrderPurchasePage({
    super.key,
    required this.dataCallback,
    this.initialMultiOrders,
    required this.pageController,
    required this.isCustomer,
    this.appBarTitle = 'Đơn hàng của bạn',
    this.actions,
    this.customerItemBuilder,
    this.vendorItemBuilder,
  });

  static const String routeName = 'purchase';
  static const String path = '/user/purchase';

  //# option properties
  final List<RespData<MultiOrderEntity>>? initialMultiOrders;

  //# required properties
  final FRespData<MultiOrderEntity> Function(OrderStatus? status) dataCallback;
  final OrderPurchasePageController pageController;
  final bool isCustomer;

  //# custom app bar
  final String appBarTitle;
  final List<Widget>? actions;

  //! Customer required
  /// call [onReceivedCallback] when customer tap received >> reload & navigate to OrderDetailPage
  final OrderPurchaseItem Function(
    OrderEntity order,
    void Function(OrderDetailEntity completedOrder) onReceivedCallback,
  )? customerItemBuilder;

  //! Vendor required
  final OrderPurchaseItem Function(
    OrderEntity order,
    void Function() reloadCallback, //> update list
  )? vendorItemBuilder;

  @override
  State<OrderPurchasePage> createState() => _OrderPurchasePageState();
}

class _OrderPurchasePageState extends State<OrderPurchasePage> {
  // late MultiOrderEntity _multiOrder;
  Future<List<RespData<MultiOrderEntity>>> _futureDataOrders() async {
    if (widget.initialMultiOrders != null) {
      return widget.initialMultiOrders!;
    }
    return Future.wait(
      List.generate(widget.pageController.tapPages.length, (index) async {
        return await widget.dataCallback(widget.pageController.tapPages[index]);
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    // if (widget.initialMultiOrder != null) {
    //   _multiOrder = widget.initialMultiOrder!;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.pageController.initialIndex, //! Control this to show the default tab
      length: widget.pageController.tapPages.length, //_totalTab,
      child: FutureBuilder<List<RespData<MultiOrderEntity>>>(
          future: _futureDataOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final listMultiOrder = snapshot.data!;

              return Scaffold(
                appBar: AppBar(
                  title: Text(widget.appBarTitle),
                  actions: widget.actions,
                  bottom: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: List.generate(
                      widget.pageController.tapPages.length, //_totalTab,
                      (index) => _buildTapButton(
                        StringHelper.getOrderStatusName(
                            widget.pageController.tapPages[index]), //(_statusFromIndex(index)),
                        listMultiOrder[index].fold(
                          (error) => 0,
                          (ok) => ok.data!.orders.length,
                        ),
                        backgroundColor: ColorHelper.getOrderStatusBackgroundColor(
                            widget.pageController.tapPages[index]), //(_statusFromIndex(index)),
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: List.generate(
                    widget.pageController.tapPages.length,
                    (index) => RefreshIndicator(
                        onRefresh: () async {
                          setState(() {});
                        },
                        child: widget.isCustomer
                            ? _buildCustomerTabBarView(
                                index: index,
                                orders: listMultiOrder[index].fold(
                                  (error) => [],
                                  (ok) => ok.data!.orders,
                                ),
                                onReceivedCallback: (completedOrder) {
                                  // - 1. update order list in [OrderPurchasePage]
                                  // - 2. navigate to [OrderDetailPage] with new [OrderDetailEntity]
                                  setState(() {});
                                  context.go(OrderDetailPage.path, extra: completedOrder);
                                },
                              )
                            : _buildVendorTabBarView(
                                index: index,
                                orders: listMultiOrder[index].fold(
                                  (error) => [],
                                  (ok) => ok.data!.orders,
                                ),
                                reloadCallback: () {
                                  setState(() {}); //just update list
                                },
                              )),
                  ),
                ),
              );
            }

            return const Scaffold(
              body: Center(
                child: Text(
                  'Đang tải...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildTapButton(String text, int total, {Color? backgroundColor}) {
    return Badge(
      label: Text(total.toString()),
      backgroundColor: backgroundColor,
      isLabelVisible: total > 0,
      offset: const Offset(12, 0),
      child: Tab(text: text),
    );
  }

  String _getEmptyMessage(OrderStatus? status) {
    switch (status) {
      case OrderStatus.WAITING:
        return 'Không có đơn hàng chờ xác nhận nào!';
      case OrderStatus.PENDING:
        return 'Không có đơn hàng chờ xác nhận nào!';
      case OrderStatus.SHIPPING:
        return 'Không có đơn hàng đang giao nào!';
      case OrderStatus.COMPLETED:
        return 'Không có đơn hàng đã giao nào!';
      case OrderStatus.CANCEL:
        return 'Không có đơn hàng đã hủy nào!';
      default:
        return 'Không có đơn hàng nào!';
    }
  }

  Icon _getIcon(OrderStatus? status) {
    switch (status) {
      case OrderStatus.WAITING:
        return const Icon(Icons.pending_actions_rounded);
      case OrderStatus.PENDING:
        return const Icon(Icons.pending_actions_rounded);
      case OrderStatus.SHIPPING:
        return const Icon(Icons.delivery_dining);
      case OrderStatus.COMPLETED:
        return const Icon(Icons.check_circle_rounded);
      case OrderStatus.CANCEL:
        return const Icon(Icons.cancel_rounded);
      default:
        return const Icon(Icons.remove_shopping_cart_rounded);
    }
  }

  Widget _buildCustomerTabBarView({
    required int index,
    required List<OrderEntity> orders,
    required void Function(OrderDetailEntity completedOrder) onReceivedCallback,
  }) {
    if (orders.isEmpty) {
      return MessageScreen.error(
        _getEmptyMessage(widget.pageController.tapPages[index]),
        _getIcon(widget.pageController.tapPages[index]),
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return widget.customerItemBuilder!(orders[index], onReceivedCallback);
      },
    );
  }

  Widget _buildVendorTabBarView({
    required int index,
    required List<OrderEntity> orders,
    required void Function() reloadCallback,
  }) {
    if (orders.isEmpty) {
      return MessageScreen.error(
        _getEmptyMessage(widget.pageController.tapPages[index]),
        _getIcon(widget.pageController.tapPages[index]),
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return widget.vendorItemBuilder!(orders[index], reloadCallback);
      },
    );
  }
}

const List<OrderStatus?> _defaultTapPages = [
  null, // null => ALL
  OrderStatus.PENDING,
  OrderStatus.PROCESSING,
  OrderStatus.SHIPPING,
  OrderStatus.DELIVERED,
  OrderStatus.COMPLETED,
  OrderStatus.CANCEL,
];

class OrderPurchasePageController {
  OrderPurchasePageController({
    this.tapPages = _defaultTapPages,
    this.initialIndex = 0,
  });

  final List<OrderStatus?> tapPages;
  final int initialIndex;
}
