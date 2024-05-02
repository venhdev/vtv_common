part './apis/auth_api.dart';
part './apis/guest_api.dart';

const int kPORT = 8585;
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

// Uri Endpoints
Uri baseUri({
  required String path,
  Map<String, String>? queryParameters,
  Map<String, String>? pathVariables,
}) {
  if (pathVariables != null) {
    pathVariables.forEach((key, value) {
      path = path.replaceFirst(':$key', value);
    });
  }
  return Uri(
    scheme: 'http',
    host: host, // change to kDOMAIN for production
    port: kPORT,
    path: '/api$path',
    queryParameters: queryParameters,
  );
}
