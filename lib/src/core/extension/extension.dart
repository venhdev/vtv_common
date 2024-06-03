// s:\flutter\src\vtv_common\lib\src\core\extension.dart exports
// generated by: https://marketplace.visualstudio.com/items?itemName=elmsec.dart-flutter-exports:

import 'dart:math';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../helpers.dart';

extension LocalNotificationHelperOnRemoteMessage on LocalNotificationHelper {
  /// Manually show FCM when app is in foreground,
  /// all information in [RemoteMessage] will be delivered to local notification as payload
  Future<void> showRemoteMessageNotification(RemoteMessage message) async {
    showNotification(
      id: Random().nextInt(1000),
      title: message.notification?.title ?? 'No title',
      body: message.notification?.body ?? 'No body',
      payload: message.toJson(),
    );
  }
}

extension RemoteMessageSerialization on RemoteMessage {
  String toJson() => jsonEncode(toMap());
  static RemoteMessage fromJson(String source) => RemoteMessage.fromMap(jsonDecode(source));

  String? get type => data['type'];
}
