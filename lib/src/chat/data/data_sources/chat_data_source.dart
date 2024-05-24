import 'package:dio/dio.dart';

import '../../../core/constants/api.dart';
import '../../../core/network/response_handler.dart';
import '../../../core/network/success_response.dart';
import '../../domain/entities/resp/chat_page_resp.dart';
import '../../domain/entities/resp/room_chat_page_resp.dart';

abstract class ChatDataSource {
  Future<SuccessResponse<RoomChatPageResp>> getPageRoomChat(int page, int size);

  Future<SuccessResponse<MessagePageResp>> getPageChatMessageByRoomId(int page, int size, String roomChatId);
}

class ChatDataSourceImpl implements ChatDataSource {
  final Dio _dio;

  ChatDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<RoomChatPageResp>> getPageRoomChat(int page, int size) async {
    final url = uriBuilder(
      path: kAPIChatRoomListPageURL,
      pathVariables: {'page': page, 'size': size}.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<RoomChatPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => RoomChatPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<MessagePageResp>> getPageChatMessageByRoomId(int page, int size, String roomChatId) async {
    final url = uriBuilder(
      path: kAPIChatMessageListURL,
      pathVariables: {
        'roomChatId': roomChatId,
        'page': page,
        'size': size,
      }.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<MessagePageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => MessagePageResp.fromMap(jsonMap),
    );
  }
}
