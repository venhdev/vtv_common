import 'dart:convert';

class SendMessageRequest {
  final String content;
  // final DateTime date;
  // final String senderUsername;
  final String receiverUsername;
  final String roomChatId;

  SendMessageRequest({
    required this.content,
    // required this.date,
    // required this.senderUsername,
    required this.receiverUsername,
    required this.roomChatId,
  });

  SendMessageRequest copyWith({
    String? content,
    DateTime? date,
    String? senderUsername,
    String? receiverUsername,
    String? roomChatId,
  }) {
    return SendMessageRequest(
      content: content ?? this.content,
      // date: date ?? this.date,
      // senderUsername: senderUsername ?? this.senderUsername,
      receiverUsername: receiverUsername ?? this.receiverUsername,
      roomChatId: roomChatId ?? this.roomChatId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'receiverUsername': receiverUsername,
      'roomChatId': roomChatId,
    };
  }

  factory SendMessageRequest.fromMap(Map<String, dynamic> map) {
    return SendMessageRequest(
      content: map['content'] as String,
      // date: DateTime.parse(map['date'] as String),
      // senderUsername: map['senderUsername'] as String,
      receiverUsername: map['receiverUsername'] as String,
      roomChatId: map['romChatId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendMessageRequest.fromJson(String source) =>
      SendMessageRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'SendMessageRequest(content: $content, date: $date, senderUsername: $senderUsername, receiverUsername: $receiverUsername, romChatId: $roomChatId)';
  // }
  @override
  String toString() {
    return 'SendMessageRequest(content: $content, receiverUsername: $receiverUsername, romChatId: $roomChatId)';
  }

  @override
  bool operator ==(covariant SendMessageRequest other) {
    if (identical(this, other)) return true;

    return other.content == content &&
        // other.date == date &&
        // other.senderUsername == senderUsername &&
        other.receiverUsername == receiverUsername &&
        other.roomChatId == roomChatId;
  }

  @override
  int get hashCode {
    // return content.hashCode ^ date.hashCode ^ senderUsername.hashCode ^ receiverUsername.hashCode ^ roomChatId.hashCode;
    return content.hashCode ^ receiverUsername.hashCode ^ roomChatId.hashCode;
  }
}
