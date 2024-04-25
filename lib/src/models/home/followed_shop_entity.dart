// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FollowedShopEntity {
  final int followedShopId;
  final int shopId;
  final String shopName;
  final String? avatar;

  const FollowedShopEntity({
    required this.followedShopId,
    required this.shopId,
    required this.shopName,
    required this.avatar,
  });

  FollowedShopEntity copyWith({
    int? followedShopId,
    int? shopId,
    String? shopName,
    String? avatar,
  }) {
    return FollowedShopEntity(
      followedShopId: followedShopId ?? this.followedShopId,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'followedShopId': followedShopId,
      'shopId': shopId,
      'shopName': shopName,
      'avatar': avatar,
    };
  }

  factory FollowedShopEntity.fromMap(Map<String, dynamic> map) {
    return FollowedShopEntity(
      followedShopId: map['followedShopId'] as int,
      shopId: map['shopId'] as int,
      shopName: map['shopName'] as String,
      avatar: map['avatar'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory FollowedShopEntity.fromJson(String source) => FollowedShopEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FollowedShopEntity(followedShopId: $followedShopId, shopId: $shopId, shopName: $shopName, avatar: $avatar)';
  }

  @override
  bool operator ==(covariant FollowedShopEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.followedShopId == followedShopId &&
      other.shopId == shopId &&
      other.shopName == shopName &&
      other.avatar == avatar;
  }

  @override
  int get hashCode {
    return followedShopId.hashCode ^
      shopId.hashCode ^
      shopName.hashCode ^
      avatar.hashCode;
  }
}
