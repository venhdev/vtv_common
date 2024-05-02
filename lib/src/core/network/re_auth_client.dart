import 'dart:async';
import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:http/http.dart';

// (new) RetryClient RetryClient(
//   Client _inner, {
//   int retries = 3,
//   FutureOr<bool> Function(BaseResponse) when = _defaultWhen,
//   FutureOr<bool> Function(Object, StackTrace) whenError = _defaultWhenError,
//   Duration Function(int) delay = _defaultDelay,
//   FutureOr<void> Function(BaseRequest, BaseResponse?, int)? onRetry,
// })
@Deprecated('Use Dio with Interceptors instead')
class ReAuthClient extends BaseClient {
  ReAuthClient(
    this._inner, {
    this.retries = 3,
    this.when = _defaultWhen,
    this.delay = _defaultDelay,
    this.onRetry,
    this.onRetryWithHeaders,
    this.whenError = _defaultWhenError,
  }) {
    RangeError.checkNotNegative(retries, 'retries');
  }

  final Client _inner;
  final int retries;
  final FutureOr<bool> Function(BaseResponse) when;
  final Duration Function(int) delay;
  final FutureOr<void> Function(BaseRequest, BaseResponse?, int)? onRetry;
  FutureOr<Map<String, String>?> Function(BaseRequest baseRequest, BaseResponse? baseResponse, int retryCount)?
      onRetryWithHeaders;
  final FutureOr<bool> Function(Object, StackTrace) whenError;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final splitter = StreamSplitter(request.finalize());

    var i = 0;
    Map<String, String>? newHeaders;

    for (;;) {
      StreamedResponse? response;
      try {
        // response = await _inner.send(newRequest ?? request);
        response = await _inner.send(_copyRequest(request, splitter.split(), headers: newHeaders));
      } catch (error, stackTrace) {
        if (i == retries || !await whenError(error, stackTrace)) rethrow;
      }

      if (response != null) {
        if (i == retries || !await when(response)) return response;
        // custom for re auth client //~await when(response)
        if (response.statusCode == 401) {
          newHeaders = await onRetryWithHeaders?.call(request, response, i);
        }

        // Make sure the response stream is listened to so that we don't leave
        // dangling connections.
        _unawaited(response.stream.listen((_) {}).cancel().catchError((_) {}));
      }

      await Future<void>.delayed(delay(i));
      await onRetry?.call(request, response, i);
      i++;
    }
  }

  /// Returns a copy of [original] with the given [body].
  StreamedRequest _copyRequest(BaseRequest original, Stream<List<int>> body, {Map<String, String>? headers}) {
    final request = StreamedRequest(original.method, original.url)
      ..contentLength = original.contentLength
      ..followRedirects = original.followRedirects
      ..headers.addAll(headers ?? original.headers)
      ..maxRedirects = original.maxRedirects
      ..persistentConnection = original.persistentConnection;

    body.listen(request.sink.add, onError: request.sink.addError, onDone: request.sink.close, cancelOnError: true);

    return request;
  }

  @override
  void close() => _inner.close();

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  // Request _creRequest(String method, Uri url, Map<String, String>? headers, [Object? body, Encoding? encoding]) {
  //   var request = Request(method, url);

  //   if (headers != null) request.headers.addAll(headers);
  //   if (encoding != null) request.encoding = encoding;
  //   if (body != null) {
  //     if (body is String) {
  //       request.body = body;
  //     } else if (body is List) {
  //       request.bodyBytes = body.cast<int>();
  //     } else if (body is Map) {
  //       request.bodyFields = body.cast<String, String>();
  //     } else {
  //       throw ArgumentError('Invalid request body "$body".');
  //     }
  //   }

  //   return request;
  // }
}

// extension BaseRequestExt on BaseRequest {
//   Request convertToRequest({
//     String? method,
//     Uri? url,
//     Map<String, String>? headers,
//     Object? body,
//     Encoding? encoding,
//   }) {
//     // return Request(method ?? this.method, url ?? this.url)
//     //   ..headers.addAll(headers ?? this.headers)
//     //   ..body = body ?? this.body
//     //   ..encoding = encoding ?? this.encoding;

//     var request = Request(method ?? this.method, url ?? this.url);

//     request.headers.addAll(headers ?? this.headers);
//     if (encoding != null) request.encoding = encoding;
//     // request.encoding = encoding ?? this.encoding;
//     if (body != null) {
//       if (body is String) {
//         request.body = body;
//       } else if (body is List) {
//         request.bodyBytes = body.cast<int>();
//       } else if (body is Map) {
//         request.bodyFields = body.cast<String, String>();
//       } else {
//         throw ArgumentError('Invalid request body "$body".');
//       }
//     }

//     return request;
//   }
// }

Duration _defaultDelay(int retryCount) => const Duration(milliseconds: 500) * math.pow(1.5, retryCount);

bool _defaultWhen(BaseResponse response) => response.statusCode == 503;

bool _defaultWhenError(Object error, StackTrace stackTrace) => false;

void _unawaited(Future<void>? f) {}


// final retryClient = RetryClient(
//   _client,
//   retries: 2,
//   when: (response) => response.statusCode == 401,
//   onRetry: (request, response, retryCount) async {
//     log('retrying... $retryCount');
//     final refreshToken = await _secureStorage.refreshToken;
//     if (refreshToken != null) {}
//   },
// );

// final reAuthClient = ReAuthClient(
//   _client,
//   retries: 2,
//   when: (response) => response.statusCode == 401,
//   onRetryWithHeaders: (baseRequest, baseResponse, retryCount) async {
//     final refreshToken = await _secureStorage.refreshToken;
//     if (refreshToken != null) {
//       final newAccessToken = await _authDataSource.getNewAccessToken(refreshToken);
//       await _secureStorage.saveOrUpdateAccessToken(newAccessToken.data); // update local access token storage

//       return baseHttpHeaders(accessToken: newAccessToken.data);
//     }
//     return null;
//   },
// );