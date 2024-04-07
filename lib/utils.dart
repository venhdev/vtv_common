import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class VTVConstants {
  static const String appName = 'Flutter Starter';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appPackage = 'com.example.flutter_starter';
}

class UiUtils {
  late BuildContext context;
  UiUtils(this.context);

  bool isDarkMode() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Future<XFile?> showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }
}

class LocalNotificationUtils {
  // final String kDefaultNotificationChannelId = 'default_notification';
  LocalNotificationUtils(this._flutterLocalNotificationsPlugin);

  // get instance of flutter_local_notifications
  FlutterLocalNotificationsPlugin get I => _flutterLocalNotificationsPlugin;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> init() async {
    InitializationSettings initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  /// Default Notification Details >> single notification
  static const NotificationDetails defaultNotificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'DEFAULT_NOTIFICATION_CHANNEL_ID',
      'Default Notification Channel',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  // Display a default notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin
        .show(
          id,
          title,
          body,
          defaultNotificationDetails,
          payload: payload,
        )
        .onError(
          (error, stackTrace) => Fluttertoast.showToast(msg: error.toString()),
        );
  }
}

//? Retrieving pending notification requests
// <https://pub.dev/packages/flutter_local_notifications#retrieving-pending-notification-requests>
// Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
//   return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
// }
//? Retrieving active notifications
// <https://pub.dev/packages/flutter_local_notifications#retrieving-active-notifications>
// Future<List<ActiveNotification>> activeNotifications() async {
//   return await _flutterLocalNotificationsPlugin.getActiveNotifications();
// }
