import 'dart:convert';

class MessageEntity {
  final String messengerId;
  final String content;
  final String senderUsername;
  final DateTime date;
  final bool usernameSenderDelete;
  final bool usernameReceiverDelete;
  final String roomChatId;

  MessageEntity({
    required this.messengerId,
    required this.content,
    required this.senderUsername,
    required this.date,
    required this.usernameSenderDelete,
    required this.usernameReceiverDelete,
    required this.roomChatId,
  });

  MessageEntity copyWith({
    String? messengerId,
    String? content,
    String? senderUsername,
    DateTime? date,
    bool? usernameSenderDelete,
    bool? usernameReceiverDelete,
    String? roomChatId,
  }) {
    return MessageEntity(
      messengerId: messengerId ?? this.messengerId,
      content: content ?? this.content,
      senderUsername: senderUsername ?? this.senderUsername,
      date: date ?? this.date,
      usernameSenderDelete: usernameSenderDelete ?? this.usernameSenderDelete,
      usernameReceiverDelete: usernameReceiverDelete ?? this.usernameReceiverDelete,
      roomChatId: roomChatId ?? this.roomChatId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messengerId': messengerId,
      'content': content,
      'senderUsername': senderUsername,
      'date': date.toIso8601String(),
      'usernameSenderDelete': usernameSenderDelete,
      'usernameReceiverDelete': usernameReceiverDelete,
      'roomChatId': roomChatId,
    };
  }

  factory MessageEntity.fromMap(Map<String, dynamic> map) {
    return MessageEntity(
      messengerId: map['messengerId'] as String,
      content: map['content'] as String,
      senderUsername: map['senderUsername'] as String,
      date: DateTime.parse(map['date'] as String),
      usernameSenderDelete: map['usernameSenderDelete'] as bool,
      usernameReceiverDelete: map['usernameReceiverDelete'] as bool,
      roomChatId: map['roomChatId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageEntity.fromJson(String source) => MessageEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatEntity(messengerId: $messengerId, content: $content, senderUsername: $senderUsername, date: $date, usernameSenderDelete: $usernameSenderDelete, usernameReceiverDelete: $usernameReceiverDelete, roomChatId: $roomChatId)';
  }

  @override
  bool operator ==(covariant MessageEntity other) {
    if (identical(this, other)) return true;

    return other.messengerId == messengerId &&
        other.content == content &&
        other.senderUsername == senderUsername &&
        other.date == date &&
        other.usernameSenderDelete == usernameSenderDelete &&
        other.usernameReceiverDelete == usernameReceiverDelete &&
        other.roomChatId == roomChatId;
  }

  @override
  int get hashCode {
    return messengerId.hashCode ^
        content.hashCode ^
        senderUsername.hashCode ^
        date.hashCode ^
        usernameSenderDelete.hashCode ^
        usernameReceiverDelete.hashCode ^
        roomChatId.hashCode;
  }
}
