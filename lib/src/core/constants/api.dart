part './apis/auth_api.dart';
part './apis/guest_api.dart';
part './apis/common_api.dart';

const int kPORT = 8585;
const String kHOST = 'example.com';
// const String kHOST = '172.16.20.208';
String host = '192.168.1.8'; // NOTE: For development purposes

// Http Headers
Map<String, String> baseHttpHeaders({
  String? refreshToken,
  String? accessToken,
}) =>
    {
      // TODO config in dio_options | remove this when migrating to dio
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      if (refreshToken != null) 'Cookie': 'refreshToken=$refreshToken',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

/// Uri Endpoints
/// - [pathVariables] must use ":key" or "{key}" as a placeholder in the path. e.g. `/api/users/:id` or `/api/users/{id}`
Uri uriBuilder({
  required String path,
  Map<String, String>? queryParameters,
  Map<String, String>? pathVariables, // the pathVariables is a map of key-value pairs
  String scheme = 'http',
  String prefix = '/api',
  // String host = 'example.com', //! NOTE: Change to kDOMAIN for production
}) {
  //> Handle multiple pattern in pathVariables
  if (pathVariables != null) {
    // check if path contain : || {*} or not
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

  path = path.startsWith('/') ? path : '/$path';
  return Uri(
    scheme: scheme,
    host: host,
    port: kPORT,
    path: '$prefix$path',
    queryParameters: queryParameters,
  );
}
