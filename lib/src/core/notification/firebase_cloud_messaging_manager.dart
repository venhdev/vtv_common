import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

/// There are a few things to keep in mind about your background message handler:
/// 1. It must not be an anonymous function.
/// 2. It must be a top-level function (e.g. not a class method which requires initialization).
/// 3. When using Flutter version 3.3.0 or higher, the message handler must be annotated with @pragma('vm:entry-point') right above the function declaration (otherwise it may be removed during tree shaking for release mode).
/// see: https://firebase.google.com/docs/cloud-messaging/flutter/receive
@pragma('vm:entry-point')
Future<void> _logBackgroundMessageHandler(RemoteMessage message) async {
  try {
    log('Got a message whilst in the background!, message: ${json.encode(message.toMap())}');
  } catch (e) {
    log('_logBackgroundMessageHandler Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
  }
}

class FirebaseCloudMessagingManager {
  FirebaseCloudMessagingManager(this._firebaseMessaging);

  final FirebaseMessaging _firebaseMessaging;
  get I => _firebaseMessaging;
  String? currentFCMToken;

  Future<void> requestPermission({
    bool alert = true,
    bool badge = true,
    bool sound = true,
    bool carPlay = false,
    bool announcement = false,
    bool criticalAlert = false,
    bool provisional = false,
  }) async {
    // request permission from user (will show prompt dialog)
    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.
    // https://firebase.flutter.dev/docs/messaging/permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: alert,
      badge: badge,
      sound: sound,
      announcement: announcement,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('[FCM] User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('[FCM] User granted provisional permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      log('[FCM] User denied permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      log('[FCM] User has not accepted or declined permission');
    }

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    currentFCMToken = fCMToken;
    log('currentFCMToken: $currentFCMToken');
  }

  /// - [onForegroundMessageReceived] callback will be called when the app is in the foreground and receives a push notification.
  /// - [onBackgroundMessageReceived] callback must be a top-level function (e.g. not a class method which requires initialization).
  /// It have to be annotated with `@pragma('vm:entry-point')`.
  /// Do not use any other package or method to show notification, if you do so, the notification will be shown twice.
  ///
  /// `@pragma('vm:entry-point') Future<void> _fcmBackgroundMessageHandler(RemoteMessage message) async {}`
  /// - [onTapMessageOpenedApp] callback will be called when the user pressed the notification when app has opened from a background state (not terminated). For terminated state, use [onTapMessageTerminatedApp].
  Future<void> listenToIncomingMessageAndHandleTap({
    void Function(RemoteMessage? remoteMessage)? onForegroundMessageReceived,
    Future<void> Function(RemoteMessage remoteMessage)? onBackgroundMessageReceived = _logBackgroundMessageHandler,
    void Function(RemoteMessage? remoteMessage)? onTapMessageOpenedApp,
    void Function(RemoteMessage? remoteMessage)? onTapMessageTerminatedApp,
  }) async {
    // foreground message handler
    FirebaseMessaging.onMessage.listen(onForegroundMessageReceived);
    // background message handler
    if (onBackgroundMessageReceived != null) FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);

    // pressed notification on background state (not terminated).
    FirebaseMessaging.onMessageOpenedApp.listen(onTapMessageOpenedApp);
    // pressed notification on terminated state.
    if (onTapMessageTerminatedApp != null) _firebaseMessaging.getInitialMessage().then(onTapMessageTerminatedApp);

    log('[FirebaseCloudMessagingManager::listenIncomingMessage] completed');
  }
}
