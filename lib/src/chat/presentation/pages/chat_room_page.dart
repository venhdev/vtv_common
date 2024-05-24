import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../../domain/entities/room_chat_entity.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key, required this.lazyListController, this.title = 'Trò chuyện'});

  final String title ;
  final LazyListController<ChatRoomEntity> lazyListController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: LazyListBuilder(
        lazyController: lazyListController,
        itemBuilder: (context, index, _) => lazyListController.build(context, index),
      ),
    );
  }
}
