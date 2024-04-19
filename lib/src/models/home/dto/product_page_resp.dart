import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core/base/base_lazy_load_page_resp.dart';
import '../product_entity.dart';

class ProductPageResp extends IBasePageResp<ProductEntity> {
  const ProductPageResp({
    required super.count,
    required super.page,
    required super.size,
    required super.totalPage,
    required super.items,
  });

  ProductPageResp copyWith({
    int? count,
    int? page,
    int? size,
    int? totalPage,
    List<ProductEntity>? items,
  }) {
    return ProductPageResp(
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
      items: items ?? this.items,
    );
  }

  factory ProductPageResp.fromMap(Map<String, dynamic> map) {
    return ProductPageResp(
      count: map['count'] as int,
      page: map['page'] as int,
      size: map['size'] as int,
      totalPage: map['totalPage'] as int,
      items: ProductEntity.fromList(map['productDTOs'] as List<dynamic>),
    );
  }

  factory ProductPageResp.fromJson(String source) =>
      ProductPageResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ProductPageResp other) {
    if (identical(this, other)) return true;

    return other.count == count &&
        other.page == page &&
        other.size == size &&
        other.totalPage == totalPage &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return count.hashCode ^ page.hashCode ^ size.hashCode ^ totalPage.hashCode ^ items.hashCode;
  }

  @override
  String toString() {
    return 'ProductDTO(count: $count, page: $page, size: $size, totalPage: $totalPage, items: $items)';
  }
}
