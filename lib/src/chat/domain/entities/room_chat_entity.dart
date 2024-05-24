import 'dart:convert';

class ChatRoomEntity {
  final String roomChatId;
  final String senderUsername;
  final String receiverUsername;
  final String lastMessage;
  final DateTime lastDate;
  final bool senderDelete;
  final bool receiverDelete;
  final bool senderSeen;
  final bool receiverSeen;

  const ChatRoomEntity({
    required this.roomChatId,
    required this.senderUsername,
    required this.receiverUsername,
    required this.lastMessage,
    required this.lastDate,
    required this.senderDelete,
    required this.receiverDelete,
    required this.senderSeen,
    required this.receiverSeen,
  });

  String getRecipientForChat(String currentLoggedInUsername) {
    //! because currentLoggedInUsername is one of the sender or receiver
    return currentLoggedInUsername == senderUsername ? receiverUsername : senderUsername;
  }

  ChatRoomEntity copyWith({
    String? roomChatId,
    String? senderUsername,
    String? receiverUsername,
    String? lastMessage,
    DateTime? lastDate,
    bool? senderDelete,
    bool? receiverDelete,
    bool? senderSeen,
    bool? receiverSeen,
  }) {
    return ChatRoomEntity(
      roomChatId: roomChatId ?? this.roomChatId,
      senderUsername: senderUsername ?? this.senderUsername,
      receiverUsername: receiverUsername ?? this.receiverUsername,
      lastMessage: lastMessage ?? this.lastMessage,
      lastDate: lastDate ?? this.lastDate,
      senderDelete: senderDelete ?? this.senderDelete,
      receiverDelete: receiverDelete ?? this.receiverDelete,
      senderSeen: senderSeen ?? this.senderSeen,
      receiverSeen: receiverSeen ?? this.receiverSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'romChatId': roomChatId,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
      'lastMessage': lastMessage,
      'lastDate': lastDate.toIso8601String(),
      'senderDelete': senderDelete,
      'receiverDelete': receiverDelete,
      'senderSeen': senderSeen,
      'receiverSeen': receiverSeen,
    };
  }

  factory ChatRoomEntity.fromMap(Map<String, dynamic> map) {
    return ChatRoomEntity(
      roomChatId: map['romChatId'] as String,
      senderUsername: map['senderUsername'] as String,
      receiverUsername: map['receiverUsername'] as String,
      lastMessage: map['lastMessage'] as String,
      lastDate: DateTime.parse(map['lastDate'] as String),
      senderDelete: map['senderDelete'] as bool,
      receiverDelete: map['receiverDelete'] as bool,
      senderSeen: map['senderSeen'] as bool,
      receiverSeen: map['receiverSeen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomEntity.fromJson(String source) => ChatRoomEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoomChatEntity(romChatId: $roomChatId, senderUsername: $senderUsername, receiverUsername: $receiverUsername, lastMessage: $lastMessage, lastDate: $lastDate, senderDelete: $senderDelete, receiverDelete: $receiverDelete, senderSeen: $senderSeen, receiverSeen: $receiverSeen)';
  }

  @override
  bool operator ==(covariant ChatRoomEntity other) {
    if (identical(this, other)) return true;

    return other.roomChatId == roomChatId &&
        other.senderUsername == senderUsername &&
        other.receiverUsername == receiverUsername &&
        other.lastMessage == lastMessage &&
        other.lastDate == lastDate &&
        other.senderDelete == senderDelete &&
        other.receiverDelete == receiverDelete &&
        other.senderSeen == senderSeen &&
        other.receiverSeen == receiverSeen;
  }

  @override
  int get hashCode {
    return roomChatId.hashCode ^
        senderUsername.hashCode ^
        receiverUsername.hashCode ^
        lastMessage.hashCode ^
        lastDate.hashCode ^
        senderDelete.hashCode ^
        receiverDelete.hashCode ^
        senderSeen.hashCode ^
        receiverSeen.hashCode;
  }
}
