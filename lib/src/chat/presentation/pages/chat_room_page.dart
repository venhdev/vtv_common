import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../../domain/entities/chat_room_entity.dart';

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
        lazyListController: lazyListController,
        itemBuilder: (context, index, _) => lazyListController.build(context, index),
      ),
    );
  }
}
