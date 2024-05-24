import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/message_entity.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.chat});

  final MessageEntity chat;

  @override
  Widget build(BuildContext context) {
    final username = context.read<AuthCubit>().state.auth!.userInfo.username!;
    final isSender = chat.senderUsername == username;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              child: Text(chat.senderUsername[0]),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(chat.content, textAlign: isSender ? TextAlign.end : TextAlign.start),
          ),
          if (isSender) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              child: Text(chat.senderUsername[0]),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
