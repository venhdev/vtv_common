import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'base/debouncer.dart';
import 'constants/types.dart';

class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class DateTimeUtils {
  /// only get date part of DateTime (remove time part). e.g: 2021-10-10 12:00:00 -> 2021-10-10 00:00:00
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}

class StringUtils {
  /// N/A: Not Available, Not Applicable, or No Answer
  static String get na => 'N/A';

  /// - Change [pattern] to change the format
  /// - [useTextValue] is used to convert date to text value like 'Today', 'Yesterday', 'Tomorrow', 'x days ago', 'x days later'
  static String convertDateTimeToString(
    DateTime date, {
    String pattern = 'dd-MM-yyyy',
    bool useTextValue = false,
  }) {
    if (useTextValue) {
      // just get day, month, year
      final now = DateTimeUtils.today();
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

  static String getVoucherDiscount({required String type, required int discount}) {
    if (type == VoucherTypes.PERCENTAGE_SYSTEM.name) {
      return 'Giảm $discount%';
    } else if (type == VoucherTypes.PERCENTAGE_SHOP.name) {
      return 'Giảm $discount%';
    } else if (type == VoucherTypes.MONEY_SHOP.name) {
      return 'Giảm đến ${formatCurrency(discount)}';
    } else if (type == VoucherTypes.MONEY_SYSTEM.name) {
      return 'Giảm đến ${formatCurrency(discount)}';
    } else if (type == VoucherTypes.FIXED_SHOP.name) {
      return 'Giảm đến ${formatCurrency(discount)}';
    } else if (type == VoucherTypes.SHIPPING.name) {
      return 'Miễn phí vận chuyển đến ${formatCurrency(discount)}';
    }
    return 'Không xác định được loại voucher';
  }

  static String getVoucherName(String type, {bool lineBreak = false}) {
    if (type == VoucherTypes.PERCENTAGE_SYSTEM.name || type == VoucherTypes.MONEY_SYSTEM.name) {
      return lineBreak ? 'VTV\nVoucher' : 'VTV Voucher';
    } else if (type == VoucherTypes.PERCENTAGE_SHOP.name ||
        type == VoucherTypes.MONEY_SHOP.name ||
        type == VoucherTypes.FIXED_SHOP.name) {
      // return 'Shop\nVoucher';
      return lineBreak ? 'Shop\nVoucher' : 'Shop Voucher';
    } else if (type == VoucherTypes.SHIPPING.name) {
      return lineBreak ? 'Free\nShipping' : 'Free Shipping';
    }
    // throw Exception('Không xác định được loại voucher');
    return 'Không xác định được loại voucher';
  }

  static String getVoucherTypeName(String type) {
    if (type == VoucherTypes.PERCENTAGE_SYSTEM.name) {
      return 'Giảm giá theo phần trăm (Hệ thống)';
    } else if (type == VoucherTypes.PERCENTAGE_SHOP.name) {
      return 'Giảm giá theo phần trăm (Shop)';
    } else if (type == VoucherTypes.MONEY_SHOP.name) {
      return 'Mã giảm theo số tiền cố định (Shop)';
    } else if (type == VoucherTypes.MONEY_SYSTEM.name) {
      return 'Mã giảm theo số tiền cố định (Hệ thống)';
    } else if (type == VoucherTypes.FIXED_SHOP.name) {
      return 'Mã giảm theo số tiền cố định (Shop)';
    } else if (type == VoucherTypes.SHIPPING.name) {
      return 'Miễn phí vận chuyển';
    } else {
      return 'Không xác định được loại voucher';
    }
  }

  static String getPaymentNameByPaymentTypes(PaymentTypes method) {
    switch (method) {
      case PaymentTypes.COD: // Cash on delivery
        return 'Thanh toán khi nhận hàng';
      case PaymentTypes.VNPay:
        return 'Thanh toán qua cổng VNPay';
      case PaymentTypes.Wallet:
        return 'Thanh toán bằng VTV Wallet';
      default:
        return method.name;
    }
  }

  static String getPaymentName(String method) {
    switch (method) {
      case 'COD': // Cash on delivery
        return 'Thanh toán khi nhận hàng';
      case 'VNPay':
        return 'Thanh toán qua cổng VNPay';
      case 'Wallet':
        return 'Thanh toán bằng VTV Wallet';
      default:
        return method;
    }
  }

  static String getOrderStatusName(OrderStatus? status) {
    switch (status) {
      case null:
        return 'Tất cả';
      case OrderStatus.WAITING:
        return 'Đang chờ'; // when create order (not place order yet) --not show in order list
      case OrderStatus.PENDING:
        return 'Chờ xác nhận';
      case OrderStatus.PROCESSING:
        return 'Đang đóng gói';
      case OrderStatus.PICKUP_PENDING:
        return 'Chờ lấy hàng';
      case OrderStatus.SHIPPING:
        return 'Đang giao';
      case OrderStatus.DELIVERED:
        return 'Đã giao';
      case OrderStatus.COMPLETED:
        return 'Hoàn thành';

      // Vendor Only
      case OrderStatus.UNPAID:
        return 'Chưa thanh toán';

      // Others
      case OrderStatus.CANCEL:
        return 'Đã hủy';

      //! Unknown status
      default:
        return status.name;
    }
  }

  static String getOrderStatusNameByDriver(OrderStatus? status) {
    switch (status) {
      // case null:
      //   return 'Tất cả';
      // case OrderStatus.WAITING:
      //   return 'WAITING'; // when create order (not place order yet) --not show in order list
      // case OrderStatus.PENDING:
      //   return 'Chờ xác nhận';
      case OrderStatus.PROCESSING:
        return 'Đang đóng gói';
      case OrderStatus.PICKUP_PENDING:
        return 'Chờ vận chuyển';
      case OrderStatus.SHIPPING:
        return 'Đang giao';
      case OrderStatus.DELIVERED:
        return 'Đã giao';
      case OrderStatus.COMPLETED:
        return 'Hoàn thành';

      // Others
      case OrderStatus.CANCEL:
        return 'Đã hủy';

      //! Unknown status
      default:
        throw UnimplementedError('Chưa xác định được trạng thái: $status');
      // return status.name;
    }
  }
}

class ColorUtils {
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

class FileUtils {
  static Future<XFile?> showImagePicker({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    return pickedFile;
  }

  static Future<MultipartFile> getMultiPartFileViaPath(
    String path, {
    String type = 'image',
    String subtype = 'jpeg',
    Map<String, String>? parameters,
  }) {
    return MultipartFile.fromFile(
      path,
      filename: path.split('/').last,
      contentType: MediaType(type, subtype, parameters),
    );
  }
}

class NetWorkUtils {
  static Future<String?> wifiIPv4() async {
    try {
      return await NetworkInfo().getWifiIP().then((ip) => ip);
    } catch (_) {
      return null;
    }
  }
}

class ConversionUtils {
  static Iterable<MapEntry<String, Object?>> flattenObjectWithPrefixIndex(
    Map<String, dynamic> objectMap, {
    required int index,
    required String prefix,
    String separator = '.',
  }) sync* {
    for (int i = 0; i < objectMap.length; i++) {
      final entry = objectMap.entries.elementAt(i);
      if (entry.value is Map<String, dynamic>) {
        yield* flattenObjectWithPrefixIndex(
          entry.value as Map<String, dynamic>,
          index: i,
          prefix: '$prefix[$index]$separator${entry.key}',
          separator: separator,
        );
      } else if (entry.value is List<Map<String, dynamic>>) {
        final list = entry.value as List<Map<String, dynamic>>;
        for (int j = 0; j < list.length; j++) {
          final item = list[j];
          yield* flattenObjectWithPrefixIndex(
            item,
            index: j,
            prefix: '$prefix[$index]$separator${entry.key}',
            separator: separator,
          );
        }
      } else {
        yield MapEntry('$prefix[$index]$separator${entry.key}', entry.value);
      }
    }
  }
}

class FunctionUtils {
  static Debouncer createDebouncer({required int milliseconds}) {
    return Debouncer(milliseconds: milliseconds);
  }
}
