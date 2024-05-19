import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });
  //! All Roles
  factory ActionButton.back(VoidCallback onBack) => ActionButton(
        label: 'Quay lại',
        onPressed: onBack,
        backgroundColor: Colors.grey.shade400,
      );

  //! Button for Customer Roles
  factory ActionButton.pay(void Function()? onPayPressed) => ActionButton(
        label: 'Thanh toán',
        onPressed: onPayPressed,
        backgroundColor: Colors.green.shade300,
      );
  factory ActionButton.customerCompleteOrder(void Function()? onCompleteOrderPressed) => ActionButton(
        label: 'Đã nhận được hàng',
        onPressed: onCompleteOrderPressed,
        backgroundColor: Colors.green.shade300,
      );
  factory ActionButton.customerCancelOrder(void Function()? onCancelOrderPressed) => ActionButton(
        label: 'Hủy đơn hàng',
        onPressed: onCancelOrderPressed,
        backgroundColor: Colors.red.shade300,
      );
  factory ActionButton.customerRePurchase(void Function()? onRePurchasePressed) => ActionButton(
        label: 'Mua lại',
        onPressed: onRePurchasePressed,
        backgroundColor: Colors.green.shade300,
      );
  factory ActionButton.customerChat(void Function()? onChatPressed) => ActionButton(
        label: 'Chat',
        onPressed: onChatPressed,
        backgroundColor: Colors.blue.shade300,
      );

  //! Button for Vendor Roles
  factory ActionButton.vendorChat(void Function()? onChatPressed) => ActionButton(
        label: 'Chat',
        onPressed: onChatPressed,
        backgroundColor: Colors.grey.shade300,
      );

  factory ActionButton.vendorAcceptOrder(void Function()? onAcceptPressed) => ActionButton(
        label: 'Nhận đơn',
        onPressed: onAcceptPressed,
        backgroundColor: Colors.blue.shade300,
      );
  factory ActionButton.vendorPackedOrder(void Function()? onPackedPressed) => ActionButton(
        label: 'Đóng gói xong',
        onPressed: onPackedPressed,
        backgroundColor: Colors.orange.shade300,
      );
  factory ActionButton.vendorAcceptCancelOrder(void Function()? onAcceptCancelPressed) => ActionButton(
        label: 'Xác nhận hủy',
        onPressed: onAcceptCancelPressed,
        backgroundColor: Colors.red.shade300,
      );

  final String label;
  final void Function()? onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
