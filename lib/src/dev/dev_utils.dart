import 'dart:developer';

import '../core/constants/api.dart';
import '../core/utils.dart';

class DevUtils {
  static Future<String?> initHostWithCurrentIPv4() async {
    return await NetWorkUtils.wifiIPv4().then((value) {
      if (value != null) {
        log('Current Host: $value will be used as host for the API calls.');
        host = value;
        return value;
      }
      return null;
    });
  }
}
