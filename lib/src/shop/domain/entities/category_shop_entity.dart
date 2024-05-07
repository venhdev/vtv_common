import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:vtv_common/src/home/domain/entities/product_entity.dart';

class CategoryShopEntity {
  final int categoryShopId;
  final int shopId;
  final String name;
  final String image;
  final int countProduct;
  final List<ProductEntity>? products;

  CategoryShopEntity({
    required this.categoryShopId,
    required this.shopId,
    required this.name,
    required this.image,
    required this.countProduct,
    required this.products,
  });

  CategoryShopEntity copyWith({
    int? categoryShopId,
    int? shopId,
    String? name,
    String? image,
    int? countProduct,
    List<ProductEntity>? products,
  }) {
    return CategoryShopEntity(
      categoryShopId: categoryShopId ?? this.categoryShopId,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      image: image ?? this.image,
      countProduct: countProduct ?? this.countProduct,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryShopId': categoryShopId,
      'shopId': shopId,
      'name': name,
      'image': image,
      'countProduct': countProduct,
      'products': products?.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryShopEntity.fromMap(Map<String, dynamic> map) {
    return CategoryShopEntity(
      categoryShopId: map['categoryShopId'] as int,
      shopId: map['shopId'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      countProduct: map['countProduct'] as int,
      // products: List<ProductEntity>.from(
      //   (map['productDTOs'] as List).map<ProductEntity>(
      //     (x) => ProductEntity.fromMap(x as Map<String, dynamic>),
      //   ),
      // ),
      products: map['productDTOs'] != null
          ? List<ProductEntity>.from(
              (map['productDTOs'] as List).map(
                (x) => ProductEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryShopEntity.fromJson(String source) =>
      CategoryShopEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryShopEntity(categoryShopId: $categoryShopId, shopId: $shopId, name: $name, image: $image, countProduct: $countProduct, products: $products)';
  }

  @override
  bool operator ==(covariant CategoryShopEntity other) {
    if (identical(this, other)) return true;

    return other.categoryShopId == categoryShopId &&
        other.shopId == shopId &&
        other.name == name &&
        other.image == image &&
        other.countProduct == countProduct &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode {
    return categoryShopId.hashCode ^
        shopId.hashCode ^
        name.hashCode ^
        image.hashCode ^
        countProduct.hashCode ^
        products.hashCode;
  }
}
