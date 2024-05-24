import 'package:vtv_common/src/chat/domain/entities/resp/chat_page_resp.dart';

import '../../../core/constants/typedef.dart';
import '../../../core/network/response_handler.dart';
import '../../domain/entities/resp/room_chat_page_resp.dart';
import '../../domain/repository/chat_repository.dart';
import '../data_sources/chat_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._chatDataSource);

  final ChatDataSource _chatDataSource;

  @override
  FRespData<RoomChatPageResp> getPageRoomChat(int page, int size) {
    return handleDataResponseFromDataSource(dataCallback: () => _chatDataSource.getPageRoomChat(page, size));
  }

  @override
  FRespData<MessagePageResp> getPageChatMessageByRoomId(int page, int size, String roomChatId) {
    return handleDataResponseFromDataSource(dataCallback: () => _chatDataSource.getPageChatMessageByRoomId(page, size, roomChatId));
  }
}
