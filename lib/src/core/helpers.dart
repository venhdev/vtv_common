import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/domain/entities/auth_entity.dart';
import '../auth/domain/entities/user_info_entity.dart';
import 'constants/types.dart';
import 'error/exceptions.dart';
import 'dart:async';
import 'dart:developer';

import 'utils.dart';

class UiHelper {
  UiHelper(this.context);

  BuildContext context;
  OverlayEntry? _entry;
  Timer? _timer;

  bool isDarkMode() {
    return Theme.of(context).brightness == Brightness.dark;
  }
  //TODO change to dark/light mode with provider

  void show({required WidgetBuilder builder, Duration? duration}) {
    _dismiss();
    _entry = OverlayEntry(builder: builder);
    Overlay.of(context, rootOverlay: true).insert(_entry!);

    if (duration != null) {
      // _timer = Timer(duration ?? const Duration(seconds: 2), _dismiss);
      final debouncer = Creator.debouncer(milliseconds: 2000);
      debouncer.run(_dismiss);
    }
  }

  void _dismiss() {
    try {
      _timer?.cancel();
      _timer = null;
      _entry?.remove();
      _entry = null;
    } catch (e) {
      log('[UiHelper] _dismiss error: $e');
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

class LocalNotificationHelper {
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

  LocalNotificationHelper(this._flutterLocalNotificationsPlugin);

  // get instance of flutter_local_notifications
  FlutterLocalNotificationsPlugin get I => _flutterLocalNotificationsPlugin;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> createAndroidNotificationChannel(AndroidNotificationChannel channel) async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// - [onDidReceiveBackgroundNotificationResponse] callback need to be annotated with `@pragma('vm:entry-point')` annotation to ensure they are not stripped out by the Dart compiler.
  Future<bool?> initializePluginAndHandler({
    // ic_launcher, ic_notification
    AndroidInitializationSettings android = const AndroidInitializationSettings('@mipmap/ic_launcher'),
    DarwinInitializationSettings? iOS,
    DarwinInitializationSettings? macOS,
    LinuxInitializationSettings? linux,
    void Function(NotificationResponse notification)? onDidReceiveNotificationResponse,
    void Function(NotificationResponse notification)? onDidReceiveBackgroundNotificationResponse,
  }) async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: iOS, // DarwinInitializationSettings(),
      macOS: macOS,
      linux: linux,
    );

    return await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );
  }

  // Display a default notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationDetails? notificationChannel = NotificationChannels.highImportanceChannel,
  }) async {
    await _flutterLocalNotificationsPlugin
        .show(
          id,
          title,
          body,
          notificationChannel,
          payload: payload,
        )
        .onError(
          (error, stackTrace) => Fluttertoast.showToast(msg: error.toString()),
        );
  }
}

class NotificationChannels {
  /// Default Channel
  static const NotificationDetails defaultImportanceChannel = NotificationDetails(
    android: AndroidNotificationDetails(
      'default_importance_channel',
      'Default Notification Channel',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      // sound: RawResourceAndroidNotificationSound('notification'),
    ),
  );

  /// High Importance Channel
  static const NotificationDetails highImportanceChannel = NotificationDetails(
    android: AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notification Channel',
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound('notification'),
    ),
  );
}
