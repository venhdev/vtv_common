import 'package:vtv_common/src/chat/domain/entities/resp/chat_page_resp.dart';

import '../../../core/constants/typedef.dart';
import '../../../core/network/response_handler.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../../domain/entities/resp/room_chat_page_resp.dart';
import '../../domain/repository/chat_repository.dart';
import '../data_sources/chat_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._chatDataSource);

  final ChatDataSource _chatDataSource;

  @override
  FRespData<ChatRoomPageResp> getPaginatedChatRoom(int page, int size) async {
    return await handleDataResponseFromDataSource(dataCallback: () => _chatDataSource.getPaginatedRoomChat(page, size));
  }

  @override
  FRespData<MessagePageResp> getPaginatedChatMessageByRoomId(int page, int size, String roomChatId) async {
    return await handleDataResponseFromDataSource(
        dataCallback: () => _chatDataSource.getPageChatMessageByRoomId(page, size, roomChatId));
  }

  @override
  FRespData<ChatRoomEntity> getOrCreateChatRoom(String recipientUsername) async {
    return await handleDataResponseFromDataSource(
        dataCallback: () => _chatDataSource.getOrCreateChatRoom(recipientUsername));
  }
}
