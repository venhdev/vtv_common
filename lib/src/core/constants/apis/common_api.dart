part of '../api.dart';

//! APIs that all roles have the same URL

//# room-chat-controller (Vendor + Customer)
const String kAPIChatRoomCreateURL = '/chat/room/create-room';
const String kAPIChatRoomListPageURL = '/chat/room/list/page/:page/size/:size';
const String kAPIChatRoomDeleteURL = '/chat/room/delete-room/:roomChatId';

//# message-controller (Vendor + Customer)
const String kAPIChatMessageListURL = '/chat/message/list/room-chat/:roomChatId/page/:page/size/:size';