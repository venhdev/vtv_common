import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http show Client;

import '../../../../core.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/dto/register_params.dart';
import '../../domain/entities/user_info_entity.dart';

// <https://pub.dev/packages/jwt_decoder>

abstract class AuthDataSource {
  //# ======================  Auth controller ======================
  Future<SuccessResponse<AuthEntity>> loginWithUsernameAndPassword(String username, String password);
  Future<SuccessResponse> register(RegisterParams registerDTO);
  Future<SuccessResponse> logoutAndRevokeRefreshToken(String refreshToken); // use for logout
  Future<SuccessResponse<String>> getNewAccessToken(String refreshToken); // handing expired token

  //# ======================  Customer controller ======================
  // Get user's profile
  Future<SuccessResponse<AuthEntity>> getUserProfile();
  // Edit user's profile
  Future<SuccessResponse<UserInfoEntity>> editUserProfile({required UserInfoEntity newInfo});

  // Request send OTP to the user's email
  Future<SuccessResponse> sendOTPForResetPasswordViaUsername(String username);
  Future<SuccessResponse> sendMailForActiveAccount(String username);
  Future<SuccessResponse> activeCustomerAccount(String username, String otp);

  // Request reset password with OTP code received from the user's email
  Future<SuccessResponse> resetPassword({
    required String username,
    required String otp,
    required String newPassword,
  });
  Future<SuccessResponse> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  });
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client _client;
  final dio.Dio _dio;
  final FirebaseCloudMessagingManager _fcmManager;
  final SecureStorageHelper _secureStorageHelper;

  AuthDataSourceImpl(this._client, this._fcmManager, this._secureStorageHelper, this._dio);

  @override
  Future<SuccessResponse<AuthEntity>> loginWithUsernameAndPassword(String username, String password) async {
    final fcmToken = _fcmManager.currentFCMToken;

    final body = {
      'username': username,
      'password': password,
      'fcmToken': fcmToken,
    };
    final url = baseUri(path: kAPIAuthLoginURL);
    log(url.toString());

    // send request
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(),
      body: jsonEncode(body),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = SuccessResponse<AuthEntity>(
        data: AuthEntity.fromMap(decodedBody),
        code: response.statusCode,
        message: decodedBody['message'],
      );
      return result;
    } else {
      throwResponseException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: url,
      );
    }
  }

  @override
  Future<SuccessResponse> logoutAndRevokeRefreshToken(String refreshToken) async {
    // body contains fcmToken
    final body = {
      'fcmToken': _fcmManager.currentFCMToken,
    };

    final url = baseUri(path: kAPIAuthLogoutURL);
    // send request
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(refreshToken: refreshToken),
      body: jsonEncode(body),
    );
    return handleResponseNoData(response, url);
  }

  @override
  Future<SuccessResponse<String>> getNewAccessToken(String refreshToken) async {
    // send request
    final url = baseUri(path: kAPIAuthRefreshTokenURL);

    final response = await _client.post(
      url,
      headers: baseHttpHeaders(refreshToken: refreshToken),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      return SuccessResponse(
        data: decodedBody['accessToken'],
        code: response.statusCode,
        message: decodedBody['message'],
      );
    } else {
      throwResponseException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: url,
      );
    }
  }

  @override
  Future<SuccessResponse> register(RegisterParams registerParams) async {
    final body = registerParams.toJson();

    final url = baseUri(path: kAPIAuthRegisterURL);

    // send request
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(),
      body: body,
    );
    return handleResponseNoData(response, url);
  }

  @override
  Future<SuccessResponse> sendOTPForResetPasswordViaUsername(String username) async {
    final url = baseUri(
      path: kAPICustomerForgotPasswordURL,
      queryParameters: {'username': username},
    );

    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseNoData(response, url);
  }

  @override
  Future<SuccessResponse> resetPassword({
    required String username,
    required String otp,
    required String newPassword,
  }) async {
    final body = {
      'username': username,
      'otp': otp,
      'newPassword': newPassword,
    };

    final url = baseUri(path: kAPICustomerResetPasswordURL);

    // send request
    final response = await _client.patch(
      url,
      headers: baseHttpHeaders(),
      body: jsonEncode(body),
    );

    return handleResponseNoData(response, url);
  }

  @override
  Future<SuccessResponse> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    final body = {
      'username': username,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    final url = baseUri(path: kAPICustomerChangePasswordURL);

    // send request
    final response = await _client.patch(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseNoData(response, url);
  }

  @override
  Future<SuccessResponse<UserInfoEntity>> editUserProfile({required UserInfoEntity newInfo}) async {
    final url = baseUri(path: kAPICustomerProfileURL);
    // send request
    final response = await _client.put(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: newInfo.toJson(),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = SuccessResponse<UserInfoEntity>(
        data: UserInfoEntity.fromMap(decodedBody['customerDTO']),
        code: response.statusCode,
        message: decodedBody['message'],
      );
      return result;
    } else {
      throwResponseException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: url,
      );
    }

    // return handleResponseNoData(response, kAPICustomerProfileURL);
  }

  @override
  Future<SuccessResponse<AuthEntity>> getUserProfile() async {
    final url = baseUri(path: kAPICustomerProfileURL);
    // send request
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = SuccessResponse<AuthEntity>(
        data: AuthEntity.fromMap(decodedBody),
        code: response.statusCode,
        message: decodedBody['message'],
      );
      return result;
    } else {
      throwResponseException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: url,
      );
    }
  }

  @override
  Future<SuccessResponse<Object?>> activeCustomerAccount(String username, String otp) async {
    final url = baseUri(path: kAPICustomerActiveAccountURL);

    final dio.Response response = await _dio.postUri(
      url,
      data: {
        'username': username,
        'otp': otp,
      },
    );

    return handleDioResponse(response, url, hasData: false);
  }

  @override
  Future<SuccessResponse<Object?>> sendMailForActiveAccount(String username) async {
    final url = baseUri(
      path: kAPICustomerSendEmailActiveAccountURL,
      queryParameters: {'username': username},
    );

    final dio.Response response = await _dio.getUri(url);

    return handleDioResponse(response, url, hasData: false);
  }
}
