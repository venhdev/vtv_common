import 'package:dio/dio.dart';

final dioOptions = BaseOptions(
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  contentType: Headers.jsonContentType,
);
