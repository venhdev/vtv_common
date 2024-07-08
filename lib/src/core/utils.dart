import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../profile/domain/entities/address_entity.dart';
import 'base/debouncer.dart';
import 'constants/types.dart';

const _defaultSeparator = '.';
const _defaultHundredAbbreviation = 'đ'; // hundred
const _defaultThousandAbbreviation = 'K'; // thousand
const _defaultMillionAbbreviation = 'M'; // million
const _defaultBillionAbbreviation = 'B'; // billion
const _defaultTrillionAbbreviation = 'T'; // trillion

class ValidationUtils {
  static bool isValidEmail(String? email) {
    if (email == null) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isUUID(String? uuid) {
    if (uuid == null) return false;
    return RegExp(r'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$').hasMatch(uuid);
  }
}

class DateTimeUtils {
  static DateTime firstDateOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime lastDateOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Parse [dateTime] to local time zone (if needed)
  /// - If [dateTime] is null, return null
  /// - If [dateTime] is not null, parse it to local time zone
  ///
  /// ! REMEMBER: this function will now throw any exception.
  static DateTime? tryParseLocal(String? dateTime) {
    if (dateTime == null) return null;
    final parsed = DateTime.tryParse(dateTime);

    if (parsed != null) {
      return parsed.toLocal();
    } else {
      return null;
    }
  }

  /// only get date part of DateTime (remove time part). e.g: 2021-10-10 12:00:00 -> 2021-10-10 00:00:00
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    required DateTime initialDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
    bool pastDatesEnabled = false,
  }) async {
    assert((firstDate != null && lastDate != null && firstDate.isBefore(lastDate)) ||
        (firstDate == null && lastDate == null));

    final now = today();
    final first = firstDate ?? (pastDatesEnabled ? DateTime(2000) : now);
    final last = lastDate ?? now.add(const Duration(days: 365 * 10));

    //? make sure initialDateTime is in range [first, last]
    //? when user choose second time initialDateTime.isAtSameMomentAs(first) 12:00
    assert(
        (initialDateTime.isAfter(first) || initialDateTime.isAtSameMomentAs(first)) && initialDateTime.isBefore(last));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: first,
      lastDate: last,
    );

    if (!context.mounted) return null;

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );
      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  // get remaining time from now to [dateTime]
  /// {defaultText} will return if [dateTime] is null
  static String getRemainingTime(
    DateTime? dateTime, {
    String defaultText = '',
    String prefixRemaining = 'Còn lại: ', // Remaining
    String prefixOverdue = 'Đã qua: ', //Overdue
    bool showOverdueTime = false, // if this false, return [defaultOverdueText] when [dateTime] is overdue
    String defaultOverdueText = '',
    String second = 's',
    String minute = 'm',
    String hour = 'h',
    String day = 'd',
    String month = 'month',
    String year = 'y',
  }) {
    if (dateTime != null) {
      Duration duration = dateTime.difference(DateTime.now());
      if (duration > Duration.zero) {
        if (duration.inSeconds < 60) {
          return '$prefixRemaining${duration.inSeconds}$second';
        } else if (duration.inMinutes < 60) {
          return '$prefixRemaining${duration.inMinutes}$minute';
        } else if (duration.inHours < 24) {
          return '$prefixRemaining${duration.inHours}$hour ${duration.inMinutes.remainder(60)}$minute';
        } else if (duration.inDays < 30) {
          return '$prefixRemaining${duration.inDays}$day ${duration.inHours.remainder(24)}$hour';
        } else if (duration.inDays < 365) {
          return '$prefixRemaining${duration.inDays ~/ 30}$month ${duration.inDays.remainder(30)}$day';
        } else {
          return '$prefixRemaining${duration.inDays ~/ 365}$year'; // so far =))
        }
      } else {
        if (!showOverdueTime) {
          return defaultOverdueText;
        }
        duration = DateTime.now().difference(dateTime); // get negative duration
        if (duration.inSeconds < 60) {
          return '$prefixOverdue${duration.inSeconds}$second';
        } else if (duration.inMinutes < 60) {
          return '$prefixOverdue${duration.inMinutes}$minute';
        } else if (duration.inHours < 24) {
          return '$prefixOverdue${duration.inHours}$hour ${duration.inMinutes.remainder(60)}$minute';
        } else if (duration.inDays < 30) {
          return '$prefixOverdue${duration.inDays}$day ${duration.inHours.remainder(24)}$hour';
        } else if (duration.inDays < 365) {
          return '$prefixOverdue${duration.inDays ~/ 30}$month ${duration.inDays.remainder(30)}$day';
        } else {
          return '$prefixOverdue${duration.inDays ~/ 365}$year'; // so far =))
        }
      }
    } else {
      return defaultText;
    }
  }
}

class StringUtils {
  /// N/A: Not Available, Not Applicable, or No Answer
  static String get na => 'N/A';

  static String getVoucherDiscount({required String type, required int discount}) {
    if (type == VoucherType.PERCENTAGE_SYSTEM.name) {
      return 'Giảm $discount%';
    } else if (type == VoucherType.PERCENTAGE_SHOP.name) {
      return 'Giảm $discount%';
    } else if (type == VoucherType.MONEY_SHOP.name) {
      return 'Giảm đến ${ConversionUtils.formatCurrency(discount)}';
    } else if (type == VoucherType.MONEY_SYSTEM.name) {
      return 'Giảm đến ${ConversionUtils.formatCurrency(discount)}';
    }
    // else if (type == VoucherTypes.SHIPPING.name) {
    //   return 'Miễn phí vận chuyển đến ${formatCurrency(discount)}';
    // }
    return 'Không xác định được loại voucher';
  }

  static String getVoucherName(String type, {bool lineBreak = false}) {
    if (type == VoucherType.PERCENTAGE_SYSTEM.name || type == VoucherType.MONEY_SYSTEM.name) {
      return lineBreak ? 'VTV\nVoucher' : 'VTV Voucher';
    } else if (type == VoucherType.PERCENTAGE_SHOP.name || type == VoucherType.MONEY_SHOP.name) {
      return lineBreak ? 'Shop\nVoucher' : 'Shop Voucher';
    }
    //  else if (type == VoucherTypes.SHIPPING.name) {
    //   return lineBreak ? 'Free\nShipping' : 'Free Shipping';
    // }
    // throw Exception('Không xác định được loại voucher');
    return 'Không xác định được loại voucher';
  }

  static String getVoucherTypeName(VoucherType type, [bool showBelongTo = false]) {
    if (type == VoucherType.PERCENTAGE_SYSTEM) {
      return 'Mã giảm giá theo phần trăm${showBelongTo ? ' của hệ thống' : ''}';
    } else if (type == VoucherType.PERCENTAGE_SHOP) {
      return 'Mã giảm giá theo phần trăm${showBelongTo ? ' của shop' : ''}';
    } else if (type == VoucherType.MONEY_SHOP) {
      return 'Mã giảm theo số tiền${showBelongTo ? ' của shop' : ''}';
    } else if (type == VoucherType.MONEY_SYSTEM) {
      return 'Mã giảm theo số tiền${showBelongTo ? ' của hệ thống' : ''}';
    } else {
      return 'Không xác định được loại voucher';
    }

    //  else if (type == VoucherTypes.SHIPPING.name) {
    //   return 'Miễn phí vận chuyển';
    // }
  }

  static String getPaymentNameByPaymentTypes(PaymentType method) {
    switch (method) {
      case PaymentType.COD: // Cash on delivery
        return 'Thanh toán khi nhận hàng';
      case PaymentType.VNPay:
        return 'Thanh toán qua cổng VNPay';
      case PaymentType.Wallet:
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
        return 'Đang xử lý';
      case OrderStatus.PICKED_UP:
        return 'Đã giao cho ĐVVC';
      case OrderStatus.PICKUP_PENDING:
        return 'Chờ lấy hàng';
      case OrderStatus.SHIPPING:
        return 'Đang giao';
      case OrderStatus.WAREHOUSE:
        return 'Lưu kho';
      case OrderStatus.DELIVERED:
        return 'Đã giao';
      case OrderStatus.RETURNED:
        return 'Trả hàng';
      case OrderStatus.REFUNDED:
        return 'Đã hoàn tiền';
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

  static String getOrderStatusNameByShipper(OrderStatus? status) {
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

  static String getAddress(AddressEntity address) {
    return '${address.fullAddress}, ${address.wardFullName}, ${address.districtFullName}, ${address.provinceFullName}';
  }
}

class ColorUtils {
  static Color? getOrderStatusBackgroundColor(OrderStatus? status, {int? shade}) {
    if (shade != null) {
      switch (status) {
        case OrderStatus.WAITING || OrderStatus.PENDING:
          return Colors.grey[shade + 200];
        case OrderStatus.PROCESSING:
          return Colors.orange[shade];
        case OrderStatus.PICKUP_PENDING:
          return Colors.orange[shade];
        case OrderStatus.SHIPPING:
          return Colors.blue[shade];
        case OrderStatus.DELIVERED:
          return Colors.blue[shade];
        case OrderStatus.COMPLETED || OrderStatus.REFUNDED:
          return Colors.green[shade];
        case OrderStatus.CANCEL:
          return Colors.red[shade];
        default:
          return Colors.red[shade];
      }
    } else {
      switch (status) {
        case OrderStatus.WAITING || OrderStatus.PENDING:
          return Colors.grey.shade400;
        case OrderStatus.PROCESSING:
          return Colors.orange.shade400;
        case OrderStatus.PICKUP_PENDING:
          return Colors.orange.shade400;
        case OrderStatus.SHIPPING:
          return Colors.blue.shade400;
        case OrderStatus.DELIVERED:
          return Colors.blue.shade400;
        case OrderStatus.COMPLETED || OrderStatus.REFUNDED:
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
  /// this function is used to convert double value to int value with ceil to 5
  /// - If value is 0, return 0
  /// - If value is 1-9, return 5 or 10
  /// - If value is 10+, return ceil to 5 first two digits
  ///
  /// eg: 0 => 0, 4 => 5, 8 => 10, 1234 => 1500, 1234567 => 1500000
  static int ceilTo5FirstTwoDigits(double value) {
    //# 0 value
    if (value == 0) return 0;

    //# 1 digit value: 1-9
    if (value < 10) {
      if (value >= 5) return 10;
      return 5;
    }

    //# 2+ digits value: >= 10
    final String valueString = value.toStringAsFixed(0);
    final String first = valueString[0];
    final String second = valueString[1];

    int firstNum = int.parse(first);
    int secondNum = int.parse(second);

    if (secondNum >= 5 && secondNum <= 9) {
      firstNum++;
      secondNum = 0;
    } else if (secondNum < 5 && secondNum >= 0) {
      secondNum = 5;
    }

    final roundedValue = firstNum.toString() + secondNum.toString();
    final roundedValueString = roundedValue + '0' * (valueString.length - 2);

    return int.parse(roundedValueString);
  }

  /// This function is used to format currency with (short name) abbreviation
  ///
  /// The [extra] just work only the length of value is greater than 3 (start from 1000).
  /// Example:
  /// - 1234 (fraction = 0) => 1K, (fraction = 1) => 1.2K, (fraction = 2) => 1.23K
  /// - 123456 (fraction = 0) => 123K, (fraction = 1) => 123.4K, (fraction = 2) => 123.45K
  /// - 12 (fraction = 2, extra = true) => 12
  /// - 1234 (fraction = 4, extra = true) => 1.2340K
  static String formatCurrencyWithAbbreviation(
    double value, {
    int fraction = 0,
    String separator = _defaultSeparator,
    bool extra = false,
    String hundredAbbreviation = _defaultHundredAbbreviation,
    String thousandAbbreviation = _defaultThousandAbbreviation,
    String millionAbbreviation = _defaultMillionAbbreviation,
    String billionAbbreviation = _defaultBillionAbbreviation,
    String trillionAbbreviation = _defaultTrillionAbbreviation,
  }) {
    int maxDigitsCanTake(int length) {
      if (length < 4) return 0;

      switch (length) {
        case 4 || 7 || 10 || 13:
          return length - 1; // eg: 1234 => 3, 1234567 => 6
        case 5 || 8 || 11 || 14:
          return length - 2; // eg: 12345 => 3, 12345678 => 6
        case 6 || 9 || 12 || 15:
          return length - 3; // eg: 123456 => 3, 123456789 => 6
        default:
          throw const FormatException('Invalid length');
      }
    }

    String mainValue(String value, int length) {
      if (value.length < 4) return value;

      final int endSub;
      switch (length) {
        case 4 || 7 || 10 || 13:
          endSub = 1;
        case 5 || 8 || 11 || 14:
          endSub = 2;
        case 6 || 9 || 12 || 15:
          endSub = 3;
        default:
          throw const FormatException('Invalid length');
      }
      return value.substring(0, endSub);
    }

    /// this [showExtra] is used to show extra zeros if the fraction is greater than the maxDigitsCanTake
    String subValue(String value, int fraction, String separator, bool showExtra) {
      if (fraction == 0 || value.length < 4) return '';

      final int startSub;
      switch (value.length) {
        case 4 || 7 || 10 || 13:
          startSub = 1;
        case 5 || 8 || 11 || 14:
          startSub = 2;
        case 6 || 9 || 12 || 15:
          startSub = 3;
        default:
          throw const FormatException('Invalid length');
      }

      final max = maxDigitsCanTake(value.length);
      if (fraction <= max) {
        return separator + value.substring(startSub, startSub + fraction);
      } else {
        if (!showExtra) return separator + value.substring(startSub, startSub + max);
        return separator + value.substring(startSub, startSub + max) + '0' * (fraction - max);
      }
    }

    String suffix(int length) {
      if (length > 12) {
        return trillionAbbreviation;
      } else if (length > 9) {
        return billionAbbreviation;
      } else if (length > 6) {
        return millionAbbreviation;
      } else if (length > 3) {
        return thousandAbbreviation;
      } else if (length > 0) {
        return hundredAbbreviation;
      }
      throw const FormatException('Invalid length');
    }

    final valueString = value.toStringAsFixed(0);
    assert(valueString.isNotEmpty, 'value must not be empty');

    final int length = valueString.length;
    if (length < 4) return valueString + suffix(length);

    return mainValue(valueString, length) + subValue(valueString, fraction, separator, extra) + suffix(length);
  }

  String roundDouble(double value) {
    String valueString = value.toStringAsFixed(0);

    return valueString;
  }

  static String formatCurrency(int value, {bool showUnit = true, String? unit = 'đ'}) {
    var f = NumberFormat.decimalPattern();
    if (!showUnit) return f.format(value);
    return '${f.format(value)}$unit';
  }

  static String thousandSeparator(int value) {
    // var dotSeparator = NumberFormat.decimalPattern('vi_VN');
    var f = NumberFormat('###,##0');
    return f.format(value);
  }

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

  static String? extractUUID(String dataContainUUID) {
    // Regular expression pattern to match a UUID
    const uuidPattern = r'[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}';
    final regex = RegExp(uuidPattern);

    // Find the first match in the message
    final match = regex.firstMatch(dataContainUUID);

    // return the matched UUID maybe null
    return match?.group(0);
  }

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

class Creator {
  static Debouncer debouncer({required int milliseconds}) {
    return Debouncer(milliseconds: milliseconds);
  }

  static Uri uri({
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? pathVariables,
    String? scheme,
    String prefix = '',
    String? host,
    int? port,
  }) {
    //> Handle 2 pattern in pathVariables >> :key or {key}
    if (pathVariables != null) {
      assert(path.contains(':') || path.contains(RegExp(r'{.*}')),
          'Not valid pathVariables in path: $path, it should be :key or {key}');

      assert(!(path.contains(':') && path.contains(RegExp(r'{.*}'))),
          'Not valid pathVariables in path: $path, it should use only one pattern');

      pathVariables.forEach((key, value) {
        if (path.contains(':$key')) {
          path = path.replaceAll(':$key', value);
        } else if (path.contains('{$key}')) {
          path = path.replaceAll('{$key}', value);
        }
      });
    }

    // only handle prefix if it is not empty
    if (prefix != '') prefix = prefix.startsWith('/') ? prefix : '/$prefix';
    path = path.startsWith('/') ? '$prefix$path' : '$prefix/$path';
    return Uri(
      path: path,
      scheme: scheme,
      host: host,
      port: port,
      queryParameters: queryParameters,
    );
  }

  static String uriPath({
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? pathVariables,
    String? scheme,
    String? prefix,
    String? host,
    int? port,
  }) {
    return uri(
      path: path,
      queryParameters: queryParameters,
      pathVariables: pathVariables,
      scheme: scheme,
      prefix: prefix ?? '',
      host: host,
      port: port,
    ).toString();
  }
}

class LaunchUtils {
  static Future<void> openMapWithQuery(final String query) async {
    // final path = 'geo://www.google.com/maps/search/?api=1&query=$query';
    // final url = Uri.parse(path);

    if (Platform.isAndroid) {
      final url = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      throw 'Unsupported platform';
    }
  }

  static Future<void> openMapNavigationWithQuery(final String query) async {
    // final path = 'geo://www.google.com/maps/search/?api=1&query=$query';
    // final url = Uri.parse(path);

    if (Platform.isAndroid) {
      // final url = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
      final url = Uri.parse('google.navigation:q=$query');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      throw 'Unsupported platform';
    }
  }

  static Future<void> openCallWithPhoneNumber(final String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    // final url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
