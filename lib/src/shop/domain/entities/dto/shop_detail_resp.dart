import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../shop_entity.dart';

class ShopDetailResp extends Equatable {
  final ShopEntity shop;
  final int countFollowed;
  final int countProduct;
  final int countCategoryShop;
  final double averageRatingShop;

  const ShopDetailResp({
    required this.shop,
    required this.countFollowed,
    required this.countProduct,
    required this.countCategoryShop,
    required this.averageRatingShop,
  });

  @override
  List<Object> get props {
    return [
      shop,
      countFollowed,
      countProduct,
      countCategoryShop,
      averageRatingShop,
    ];
  }

  // ShopDetailResp copyWith({
  //   ShopEntity? shop,
  //   int? countFollowed,
  //   int? countProduct,
  //   int? countCategoryShop,
  //   double? averageRatingShop,
  //   String? shopUsername,
  // }) {
  //   return ShopDetailResp(
  //     shop: shop ?? this.shop,
  //     countFollowed: countFollowed ?? this.countFollowed,
  //     countProduct: countProduct ?? this.countProduct,
  //     countCategoryShop: countCategoryShop ?? this.countCategoryShop,
  //     averageRatingShop: averageRatingShop ?? this.averageRatingShop,
  //     shopUsername: shopUsername ?? this.shopUsername,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'shop': shop.toMap(),
  //     'countFollowed': countFollowed,
  //     'countProduct': countProduct,
  //     'countCategoryShop': countCategoryShop,
  //     'averageRatingShop': averageRatingShop,
  //   };
  // }

  factory ShopDetailResp.fromMap(Map<String, dynamic> map) {
    return ShopDetailResp(
      shop: ShopEntity.fromMap(map['shopDTO'] as Map<String, dynamic>),
      countFollowed: map['countFollowed'] as int,
      countProduct: map['countProduct'] as int,
      countCategoryShop: map['countCategoryShop'] as int,
      averageRatingShop: map['averageRatingShop'] as double,
    );
  }

  // String toJson() => json.encode(toMap());

  factory ShopDetailResp.fromJson(String source) => ShopDetailResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
