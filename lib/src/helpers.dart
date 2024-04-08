import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/types.dart';
import 'core/error/exceptions.dart';
import 'models/auth/auth_entity.dart';
import 'models/auth/auth_model.dart';
import 'models/auth/user_info_entity.dart';

class ValidatorHelper {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class StringHelper {
  /// - Change [pattern] to change the format
  ///
  /// - [useTextValue] is used to convert date to text value like 'Today', 'Yesterday', 'Tomorrow', 'x days ago', 'x days later'
  static String convertDateTimeToString(
    DateTime date, {
    String pattern = 'dd-MM-yyyy',
    bool useTextValue = false,
  }) {
    if (useTextValue) {
      // just get day, month, year
      final now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime tomorrow = today.add(const Duration(days: 1));
      DateTime yesterday = today.subtract(const Duration(days: 1));
      if (date == today) {
        return 'Hôm nay';
      } else if (date == tomorrow) {
        return 'Ngày mai';
      } else if (date == yesterday) {
        return 'Hôm qua';
      } else if (date.isAfter(today)) {
        final remaining = date.difference(today).inDays; // get remaining days
        return '$remaining ngày nữa';
      } else if (date.isBefore(today)) {
        final passed = today.difference(date).inDays; // get passed days
        return '$passed ngày trước';
      }
    }

    return DateFormat(pattern).format(date);
  }

  static String formatCurrency(int value, {bool showUnit = true, String? unit = 'đ'}) {
    var f = NumberFormat.decimalPattern();
    if (!showUnit) return f.format(value);
    return '${f.format(value)}$unit';
  }

  static String getVoucherDescribe({required String type, required int discount}) {
    if (type == VoucherTypes.PERCENTAGE_SYSTEM.name) {
      return 'Giảm $discount%';
    } else if (type == VoucherTypes.PERCENTAGE_SHOP.name) {
      return 'Giảm $discount%';
    } else if (type == VoucherTypes.MONEY_SHOP.name) {
      return 'Giảm ${formatCurrency(discount)}';
    } else if (type == VoucherTypes.MONEY_SYSTEM.name) {
      return 'Giảm ${formatCurrency(discount)}';
    } else if (type == VoucherTypes.FIXED_SHOP.name) {
      return 'Giảm ${formatCurrency(discount)}';
    } else if (type == VoucherTypes.SHIPPING.name) {
      return 'Miễn phí vận chuyển đến ${formatCurrency(discount)}';
    }
    throw Exception('Không xác định được loại voucher');
  }

  static String getPaymentName(String method) {
    switch (method) {
      case 'COD': // Cash on delivery
        return 'Thanh toán khi nhận hàng';
      case 'MOMO':
        return 'MoMo';
      case 'zalopay':
        return 'ZaloPay';
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'MasterCard';
      default:
        return method;
    }
  }

  static String getOrderStatusName(OrderStatus? status) {
    switch (status) {
      case null:
        return 'Tất cả';
      case OrderStatus.WAITING:
        return 'Draft'; // when create order (not place order yet) --not show in order list
      case OrderStatus.PENDING:
        return 'Chờ xác nhận';
      case OrderStatus.SHIPPING:
        return 'Đang giao';
      case OrderStatus.COMPLETED:
        return 'Hoàn thành';
      case OrderStatus.DELIVERED:
        return 'Đã giao';
      case OrderStatus.CANCEL:
        return 'Đã hủy';
      // Vendor Only
      case OrderStatus.PROCESSING:
        return 'Đang xử lý';

      //! Unknown status
      default:
        return status.name;
    }
  }
}

class ColorHelper {
  static Color? getOrderStatusBackgroundColor(OrderStatus? status) {
    switch (status) {
      case OrderStatus.WAITING:
        return Colors.grey;
      case OrderStatus.PENDING:
        return Colors.grey;
      case OrderStatus.SHIPPING:
        return Colors.blue;
      case OrderStatus.COMPLETED:
        return Colors.green;
      case OrderStatus.CANCEL:
        return Colors.red.shade400;
      default:
        return null;
    }
  }
}

class SecureStorageHelper {
  final _keyAuth = 'AUTHENTICATION';

  SecureStorageHelper(this._storage);
  final FlutterSecureStorage _storage;

  FlutterSecureStorage get I => _storage;

  Future<bool> get isLogin => _storage.containsKey(key: _keyAuth);

  // get roles
  Future<List<String>?> get roles async {
    try {
      final auth = await readAuth();
      return auth?.userInfo.roles!.map((e) => e.toString()).toList();
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi đọc thông tin người dùng!');
    }
  }

  /// get access token from local storage.
  /// - return null if not found (not login yet)
  Future<String?> get accessToken async {
    try {
      final auth = await readAuth();
      if (auth == null) return null;
      return auth.accessToken;
    } catch (e) {
      return null;
    }
  }

  /// get username from local storage.
  /// - return null if not found
  Future<String?> get username async {
    try {
      final auth = await readAuth();
      return auth?.userInfo.username;
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi đọc thông tin người dùng!');
    }
  }

  Future<AuthEntity?> readAuth() async {
    final data = await _storage.read(key: _keyAuth);
    if (data?.isNotEmpty ?? false) {
      return AuthModel.fromJson(data!).toEntity();
    } else {
      return null;
    }
  }

  Future<void> cacheAuth(String jsonData) async {
    try {
      await _storage.write(key: _keyAuth, value: jsonData);
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi lưu thông tin người dùng!');
    }
  }

  // update user info
  Future<void> updateUserInfo(UserInfoEntity newInfo) async {
    try {
      final auth = await readAuth();
      final newAuth = auth?.copyWith(userInfo: newInfo);
      if (newAuth == null) throw CacheException(message: 'Không tìm thấy thông tin người dùng!');

      await cacheAuth(AuthModel.fromEntity(newAuth).toJson());
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi cập nhật thông tin người dùng!');
    }
  }

  Future<void> deleteAuth() async => await _storage.delete(key: _keyAuth);

  Future<void> deleteAll() async => await _storage.deleteAll();
}

class SharedPreferencesHelper {
  final String _keyStarted = 'STARTED';
  final String _keyTheme = 'THEME';

  SharedPreferencesHelper(this._prefs);

  SharedPreferences get I => _prefs;
  final SharedPreferences _prefs;

  //.---------------------First RUN-----------------------
  bool get isFirstRun => _prefs.getBool(_keyStarted) ?? true;

  Future<void> setStarted(bool value) async {
    await _prefs.setBool(_keyStarted, value);
  }

  //.---------------------Dark Mode-----------------------
  bool get isDarkMode => _prefs.getBool(_keyTheme) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyTheme, value);
  }
}
