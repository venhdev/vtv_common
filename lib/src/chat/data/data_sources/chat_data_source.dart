import 'package:dio/dio.dart';

import '../../../core/constants/api.dart';
import '../../../core/network/response_handler.dart';
import '../../../core/network/success_response.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../../domain/entities/resp/chat_page_resp.dart';
import '../../domain/entities/resp/room_chat_page_resp.dart';

abstract class ChatDataSource {
  //# room-chat-controller
  Future<SuccessResponse<ChatRoomPageResp>> getPaginatedRoomChat(int page, int size);
  Future<SuccessResponse<ChatRoomEntity>> getOrCreateChatRoom(String recipientUsername);

  //# message-controller
  Future<SuccessResponse<MessagePageResp>> getPageChatMessageByRoomId(int page, int size, String roomChatId);
}

class ChatDataSourceImpl implements ChatDataSource {
  final Dio _dio;

  ChatDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<ChatRoomPageResp>> getPaginatedRoomChat(int page, int size) async {
    final url = uriBuilder(
      path: kAPIChatRoomListPageURL,
      pathVariables: {'page': page, 'size': size}.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<ChatRoomPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ChatRoomPageResp.fromMap(jsonMap),
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

  @override
  Future<SuccessResponse<ChatRoomEntity>> getOrCreateChatRoom(String recipientUsername) async {
    final url = uriBuilder(
      path: kAPIChatRoomCreateURL,
      queryParameters: {'receiverUsername': recipientUsername},
    );

    final response = await _dio.postUri(url);

    return handleDioResponse<ChatRoomEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ChatRoomEntity.fromMap(jsonMap['roomChatDTO']),
    );
  }
}
