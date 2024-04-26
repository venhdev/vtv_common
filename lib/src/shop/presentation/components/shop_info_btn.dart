import 'package:flutter/material.dart';

Color? _backgroundColor(ShopInfoEntry entry) {
  switch (entry) {
    case ShopInfoEntry.follow:
      return Colors.green.shade100;
    case ShopInfoEntry.unfollow:
      return Colors.red.shade100;
    default:
      return null;
  }
}

enum ShopInfoEntry {
  chat('Chat'),
  follow('+ Theo dõi'),
  unfollow('Bỏ theo dõi'),
  view('Xem shop'),
  loading('Đang tải...');

  const ShopInfoEntry(
    this.label,
  );
  final String label;
}

class ShopInfoButton extends StatelessWidget {
  const ShopInfoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
  });

  factory ShopInfoButton.view(void Function()? onPressed) {
    return ShopInfoButton(
      label: ShopInfoEntry.view.label,
      onPressed: onPressed,
      backgroundColor: Colors.blue.shade100,
    );
  }

  factory ShopInfoButton.loading() {
    return ShopInfoButton(
      label: ShopInfoEntry.loading.label,
      onPressed: null,
      backgroundColor: _backgroundColor(ShopInfoEntry.loading),
    );
  }

  factory ShopInfoButton.unFollow(void Function() onUnFollowPressed) {
    return ShopInfoButton(
      label: ShopInfoEntry.unfollow.label,
      // onPressed: () async {
      //   onFollowChanged(await _handleUnFollowShop(followedShopId));
      // },
      onPressed: onUnFollowPressed,
      backgroundColor: _backgroundColor(ShopInfoEntry.unfollow),
    );
  }

  factory ShopInfoButton.follow(void Function() onFollowPressed) {
    return ShopInfoButton(
      label: ShopInfoEntry.follow.label,
      // onPressed: () async {
      //   final followedShopId = await _handleFollowShop(shopId);
      //   onFollowChanged(followedShopId);
      // },
      onPressed: onFollowPressed,
      backgroundColor: _backgroundColor(ShopInfoEntry.follow),
    );
  }

  factory ShopInfoButton.chat(void Function()? onPressed) {
    return ShopInfoButton(
      label: ShopInfoEntry.chat.label,
      onPressed: onPressed,
      backgroundColor: Colors.blue.shade100,
    );
  }

  final Color? backgroundColor;
  final String label;

  /// return true when success
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: backgroundColor,
        // side: BorderSide.none,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
