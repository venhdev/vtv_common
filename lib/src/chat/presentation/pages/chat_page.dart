import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../core/constants/api.dart';
import '../../../core/presentation/components/lazy_list_builder.dart';
import '../../../core/themes.dart';
import '../../../core/utils.dart';
import '../../domain/entities/entities.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.lazyListController,
    required this.roomChatId,
    required this.receiverUsername,
  });

  final String roomChatId;
  final String receiverUsername;

  final LazyListController<MessageEntity> lazyListController;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late StompClient stompClient;
  bool isConnected = false;
  final TextEditingController _chatController = TextEditingController();

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      // headers: {'Authorization': 'Bearer ${context.read<AuthCubit>().state.auth!.accessToken}'},
      destination: BuilderUtils.uriPath(
        path: '/room/:roomChatId/chat',
        pathVariables: {'roomChatId': widget.roomChatId},
      ),
      callback: (frame) {
        log('(callback) frame.body: ${frame.body.toString()}');

        if (frame.body == null) return;
        try {
          final MessageEntity msg = MessageEntity.fromJson(frame.body!);
          widget.lazyListController.insertAt(0, msg);
        } catch (e) {
          log('Error: $e');
        }
      },
    );

    setState(() {
      isConnected = true;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.lazyListController.init();

    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://$host:$kPORT/ws-stomp?token=${context.read<AuthCubit>().state.auth!.accessToken}',
        // webSocketConnectHeaders: {'Authorization': 'Bearer ${context.read<AuthCubit>().state.auth!.accessToken}'},
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => log(error.toString()),
        onDisconnect: (dynamic frame) => log('onDisconnect: $frame'),
        onStompError: (err) => log(err.toString()),
        onWebSocketDone: () {
          log('onWebSocketDone!');
        },
      ),
    )..activate();
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //# connection status
        if (!isConnected) Text('Đang kết nối...', textAlign: TextAlign.center, style: VTVTheme.hintTextStyle),

        //# chat list
        Expanded(
          child: LazyListBuilder(
            lazyController: widget.lazyListController,
            itemBuilder: (context, index, _) => widget.lazyListController.build(context, index),
          ),
        ),
        //# chat input
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  keyboardType: TextInputType.multiline,
                  maxLength: 254,
                  // hide the max length text counter
                  buildCounter: (_, {required currentLength, required isFocused, required maxLength}) => null,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed:
                    (isConnected && context.read<AuthCubit>().state.auth != null) ? _handleSendChatMessage : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSendChatMessage() {
    final String msgRequest = SendMessageRequest(
      content: _chatController.text,
      // date: DateTime.now(),
      // senderUsername: context.read<AuthCubit>().state.auth!.userInfo.username!,
      receiverUsername: widget.receiverUsername,
      roomChatId: widget.roomChatId,
    ).toJson();

    if (stompClient.connected) {
      stompClient.send(
        destination: '/app/chat',
        body: msgRequest,
        headers: {'Authorization': context.read<AuthCubit>().state.auth!.accessToken},
      );

      _chatController.clear();
    } else {
      log('stompClient is not connected!');
    }
  }
}
