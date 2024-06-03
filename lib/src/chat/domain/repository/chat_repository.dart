import 'package:vtv_common/core.dart';

import '../../../../chat.dart';

abstract class ChatRepository {
  //# room-chat-controller
  FRespData<ChatRoomPageResp> getPaginatedChatRoom(int page, int size);
  FRespData<ChatRoomEntity> getOrCreateChatRoom(String recipientUsername);
  //# message-controller
  FRespData<MessagePageResp> getPaginatedChatMessageByRoomId(int page, int size, String roomChatId);
}
