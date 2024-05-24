import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';

import '../../domain/entities/room_chat_entity.dart';

class ChatRoomItem extends StatelessWidget {
  const ChatRoomItem({
    super.key,
    required this.room,
    this.onPressed,
  });

  final ChatRoomEntity room;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Text(
        room.receiverUsername == context.read<AuthCubit>().state.auth?.userInfo.username!
            ? room.senderUsername
            : room.receiverUsername,
      ),
      subtitle: Text(room.lastMessage),
    );
  }
}
