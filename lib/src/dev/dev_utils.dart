import 'dart:developer';

import '../core/constants/api.dart';
import '../core/utils.dart';

class DevUtils {
  static Future<String?> initHostWithCurrentIPv4([String? ipv4]) async {
    if (ipv4 != null) {
      log('Specified Host: $ipv4 will be used as host for the API calls.');
      host = ipv4;
      return ipv4;
    }
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
