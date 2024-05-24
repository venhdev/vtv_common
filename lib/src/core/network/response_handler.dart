import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' show Response;
import 'package:dio/dio.dart' as dio;

import '../constants/typedef.dart';
import '../error/exceptions.dart';
import 'error_response.dart';
import 'success_response.dart';

void logResp(Response response, Uri url, Map<String, dynamic> decodedBody) {
  log('call API: ${url.path} + queryParameters: ${url.queryParameters}');
  log('=> statusCode: ${response.statusCode} with body: ${decodedBody['message'] ?? 'no message'}');
}

void logDioResp(dio.Response response, Uri url) {
  log('call API: ${url.path} + queryParameters: ${url.queryParameters}');
  log('=> statusCode: ${response.statusCode} with body: ${response.data['message'] ?? 'no message'}');
}

SuccessResponse handleResponseNoData(Response response, Uri url) {
  // decode response using utf8
  final utf8BodyMap = utf8.decode(response.bodyBytes);
  final decodedBody = jsonDecode(utf8BodyMap);

  logResp(response, url, decodedBody); // NOTE: dev

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return SuccessResponse(
      code: response.statusCode,
      message: decodedBody['message'],
      status: decodedBody['status'] ?? 'unknown status',
    );
  } else {
    throwResponseException(
      code: response.statusCode,
      message: decodedBody['message'],
      url: url,
    );
  }
}

SuccessResponse handleDioResponseNoData(dio.Response response, Uri url) {
  logDioResp(response, url); // NOTE: dev

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    return SuccessResponse(
      code: response.statusCode,
      message: response.data['message'],
      status: response.data['status'] ?? 'unknown status',
    );
  } else {
    throwResponseException(
      code: response.statusCode,
      message: response.data['message'],
      url: url,
    );
  }
}

/// Use to handle http Response contain data from API
/// - [T] is the type of data that will be returned wrapped in [SuccessResponse] (the expected data type).
/// - [R] is the type of data returned from the API's response body, Dio automatically decodes the response body to this type.
/// (typically `Map<String, dynamic>`). You need to pass a function that will parse this data to the expected data type [T].
///
/// Set [hasData] to false when the response body doesn't contain data, so the [parse] function is not required. it will return [SuccessResponse] with code, status, message.
///
/// ! REMEMBER: [parse] is a function that will parse the data from the API's response body to the expected data type [T].
/// [R] is response body, so it's typically need to access the data inside: e.g. data['userDTO'].
/// Then the parse function will be like this:
///   - [T] is an `Object` use `(jsonMap) => YourEntity.fromMap(jsonMap['json_key'])`
///   - [T] is `List<Object>` use `(jsonMap) => (jsonMap['json_key'] as List).map((e) => YourEntity.fromMap(e)).toList()`
///
/// "json_key" is the key of the data you want to parse from the response body match with the expected data type [T]. eg: 'userDTO', 'categoryShopDTOs'.
SuccessResponse<T> handleDioResponse<T, R>(
  dio.Response response,
  Uri url, {
  //! REMEMBER: parse is a function that will parse the data from the API's response body to the expected data type [T].
  //? [R] is response body, so it's typically need to access the data inside: e.g. data['userDTO'].
  //? then the parse function will be like this: (data) => UserEntity.fromMap(data['userDTO'])
  T Function(R data)? parse,
  bool hasData = true,
}) {
  assert((hasData && parse != null) || !hasData, 'parse function is required when hasData');
  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    if (!hasData) {
      return SuccessResponse(
        code: response.statusCode,
        message: response.data['message'] ?? 'no message',
        status: response.data['status'] ?? 'unknown status',
      );
    } else {
      //! condition 'R is Map<String, dynamic>' always return false => use response.data
      final result = parse!(response.data);
      if (response.data is Map<String, dynamic>) {
        return SuccessResponse(
          data: result,
          code: response.statusCode,
          message: response.data['message'] ?? 'no message',
          status: response.data['status'] ?? 'unknown status',
        );
      } else {
        return SuccessResponse(
          data: result,
          code: response.statusCode,
        );
      }
    }
  } else {
    throwResponseException(
      code: response.statusCode,
      message: response.data['message'] ?? 'no message',
      url: url,
    );
  }
}

/// use to handle http Response contain data from API
SuccessResponse<T> handleResponseWithData<T>(
  Response response,
  Uri url,
  T Function(Map<String, dynamic> dataMap) fromMap,
) {
  // decode response using utf8
  final utf8BodyMap = utf8.decode(response.bodyBytes);
  final decodedBodyMap = jsonDecode(utf8BodyMap);

  logResp(response, url, decodedBodyMap); // NOTE: dev

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final result = fromMap(decodedBodyMap);
    return SuccessResponse<T>(
      data: result,
      code: response.statusCode,
      message: decodedBodyMap['message'],
      status: decodedBodyMap['status'] ?? 'unknown status',
    );
  } else {
    throwResponseException(
      code: response.statusCode,
      message: decodedBodyMap['message'],
      url: url,
    );
  }
}

Never throwResponseException({
  String? message,
  int? code,
  Uri? url,
}) {
  if (code != null) {
    if (code >= 500) {
      throw ServerException(
        code: code,
        message: message ?? 'Server error',
        uri: url,
      );
    } else if (code >= 400) {
      throw ClientException(
        code: code,
        message: message ?? 'Client error',
        uri: url,
      );
    }
  }

  throw Exception(message);
}

// handle data response from data source
FRespData<T> handleDataResponseFromDataSource<T>({
  required Future<SuccessResponse<T>> Function() dataCallback,
}) async {
  try {
    return Right(await dataCallback());
  } on ClientException catch (e) {
    return Left(ClientError(code: e.code, message: e.message));
  } on ServerException catch (e) {
    return Left(ServerError(code: e.code, message: e.message));
  } catch (e) {
    return Left(UnexpectedError(message: e.toString()));
  }
}

// handle success response from data source
FRespEither handleSuccessResponseFromDataSource({
  // SuccessResponse? data,
  required Future<SuccessResponse> Function() noDataCallback,
}) async {
  try {
    return Right(await noDataCallback());
  } on ClientException catch (e) {
    return Left(ClientError(code: e.code, message: e.message));
  } on ServerException catch (e) {
    return Left(ServerError(code: e.code, message: e.message));
  } catch (e) {
    return Left(UnexpectedError(message: e.toString()));
  }
}
