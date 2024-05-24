import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../../core/base/base_lazy_load_page_resp.dart';
import '../message_entity.dart';

class MessagePageResp extends IBasePageResp<MessageEntity> {
  const MessagePageResp({
    required super.items,
    super.count,
    super.page,
    super.size,
    super.totalPage,
  });

  MessagePageResp copyWith({
    List<MessageEntity>? items,
    int? count,
    int? page,
    int? size,
    int? totalPage,
  }) {
    return MessagePageResp(
      items: items ?? this.items,
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'items': items.map((x) => x.toMap()).toList(),
  //     'count': count,
  //     'page': page,
  //     'size': size,
  //     'totalPage': totalPage,
  //   };
  // }

  factory MessagePageResp.fromMap(Map<String, dynamic> map) {
    return MessagePageResp(
      items: List<MessageEntity>.from(
        (map['messageDTOs'] as List).map<MessageEntity>(
          (x) => MessageEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      count: map['count'] != null ? map['count'] as int : null,
      page: map['page'] != null ? map['page'] as int : null,
      size: map['size'] != null ? map['size'] as int : null,
      totalPage: map['totalPage'] != null ? map['totalPage'] as int : null,
    );
  }

  // String toJson() => json.encode(toMap());

  factory MessagePageResp.fromJson(String source) => MessagePageResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatPageResp(items: $items, count: $count, page: $page, size: $size, totalPage: $totalPage)';
  }

  @override
  bool operator ==(covariant MessagePageResp other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.items, items) &&
        other.count == count &&
        other.page == page &&
        other.size == size &&
        other.totalPage == totalPage;
  }

  @override
  int get hashCode {
    return items.hashCode ^ count.hashCode ^ page.hashCode ^ size.hashCode ^ totalPage.hashCode;
  }
}
