import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/types.dart';
import 'error/exceptions.dart';
import '../auth/domain/entities/auth_entity.dart';
import '../auth/domain/entities/user_info_entity.dart';

class ValidatorHelper {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class StringHelper {
  /// N/A: Not Available, Not Applicable, or No Answer
  static String get na => 'N/A';

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
  static Color? getOrderStatusBackgroundColor(OrderStatus? status, {int? shade}) {
    if (shade != null) {
      switch (status) {
        case OrderStatus.WAITING:
          return Colors.grey[shade + 200];
        case OrderStatus.PENDING:
          return Colors.grey[shade + 200];
        case OrderStatus.PROCESSING:
          return Colors.orange[shade];
        case OrderStatus.PICKUP_PENDING:
          return Colors.orange[shade];
        case OrderStatus.SHIPPING:
          return Colors.blue[shade];
        case OrderStatus.DELIVERED:
          return Colors.blue[shade];
        case OrderStatus.COMPLETED:
          return Colors.green[shade];
        case OrderStatus.CANCEL:
          return Colors.red[shade];
        default:
          return Colors.red[shade];
      }
    } else {
      switch (status) {
        case OrderStatus.WAITING:
          return Colors.grey.shade400;
        case OrderStatus.PENDING:
          return Colors.grey.shade400;
        case OrderStatus.PROCESSING:
          return Colors.orange.shade400;
        case OrderStatus.PICKUP_PENDING:
          return Colors.orange.shade400;
        case OrderStatus.SHIPPING:
          return Colors.blue.shade400;
        case OrderStatus.DELIVERED:
          return Colors.blue.shade400;
        case OrderStatus.COMPLETED:
          return Colors.green;
        case OrderStatus.CANCEL:
          return Colors.red.shade400;
        default:
          return Colors.red.shade400;
      }
    }
  }
}

class SecureStorageHelper {
  final _keyUserInfo = 'USER_INFO';
  final _keyAccessToken = 'ACCESS_TOKEN';
  final _keyRefreshToken = 'REFRESH_TOKEN';

  SecureStorageHelper(this._storage);
  final FlutterSecureStorage _storage;

  FlutterSecureStorage get I => _storage;

  //*-------------------------------------------------Authentication Methods---------------------------------------------------*//

  //*---------------------GET-----------------------*//

  Future<bool> get isLogin => _storage.containsKey(key: _keyAccessToken);

  /// return true if access token is expired
  ///
  /// return null if not login yet
  Future<bool?> get isTokenHasExpired async {
    final accessToken = await this.accessToken;
    if (accessToken != null) {
      return JwtDecoder.isExpired(accessToken);
    } else {
      return null;
    }
  }

  /// get access token from local storage.
  /// - return null if not found (not login yet)
  Future<String?> get accessToken async {
    try {
      return await _storage.read(key: _keyAccessToken);
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi đọc access token!');
    }
  }

  /// get refresh token from local storage.
  /// - return null if not found (not login yet)
  Future<String?> get refreshToken async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi đọc refresh token!');
    }
  }

  Future<List<Role>?> get roles async {
    try {
      final info = await getUserInfo;
      return info?.roles!.map((e) => e).toList();
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi đọc thông tin người dùng!');
    }
  }

  /// get username from local storage.
  /// - return null if not found
  Future<String?> get username async {
    try {
      final info = await getUserInfo;
      return info?.username;
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi đọc thông tin người dùng!');
    }
  }

  Future<UserInfoEntity?> get getUserInfo async {
    try {
      final data = await _storage.read(key: _keyUserInfo);
      if (data?.isNotEmpty ?? false) {
        return UserInfoEntity.fromJson(data!);
      } else {
        return null;
      }
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi đọc thông tin người dùng!');
    }
  }

  Future<AuthEntity> readAuth() async {
    final userInfo = await getUserInfo;
    final accessToken = await this.accessToken;
    final refreshToken = await this.refreshToken;
    if (userInfo == null || accessToken == null || refreshToken == null) {
      throw CacheException(message: 'Không tìm thấy thông tin người dùng!');
    }
    return AuthEntity(
      userInfo: userInfo,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  //*---------------------WRITE-----------------------*//

  Future<void> cacheAuth(AuthEntity auth) async {
    await saveOrUpdateUserInfo(auth.userInfo);
    await saveOrUpdateAccessToken(auth.accessToken);
    await saveOrUpdateRefreshToken(auth.refreshToken);
  }

  Future<void> saveOrUpdateUserInfo(UserInfoEntity userInfo) async {
    try {
      await _storage.write(key: _keyUserInfo, value: userInfo.toJson());
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi lưu (cập nhật) thông tin người dùng!');
    }
  }

  Future<void> saveOrUpdateAccessToken(String accessToken) async {
    try {
      await _storage.write(key: _keyAccessToken, value: accessToken);
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi lưu (cập nhật) access token!');
    }
  }

  Future<void> saveOrUpdateRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi lưu (cập nhật) refresh token!');
    }
  }

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
