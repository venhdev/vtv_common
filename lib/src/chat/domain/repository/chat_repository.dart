import 'package:vtv_common/core.dart';

import '../entities/resp/chat_page_resp.dart';
import '../entities/resp/room_chat_page_resp.dart';

abstract class ChatRepository {
  //# room-chat-controller
  FRespData<RoomChatPageResp> getPageRoomChat(int page, int size);
  //# message-controller
  FRespData<MessagePageResp> getPageChatMessageByRoomId(int page, int size, String roomChatId);
}
