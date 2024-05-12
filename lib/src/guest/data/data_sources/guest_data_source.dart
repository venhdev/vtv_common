import 'package:dio/dio.dart';

import '../../../core/constants/api.dart';
import '../../../core/network/network.dart';
import '../../../home/domain/entities/category_entity.dart';
import '../../../profile/domain/entities/entities.dart';
import '../../../shop/domain/entities/category_shop_entity.dart';
import '../../../shop/domain/entities/dto/shop_detail_resp.dart';

abstract class GuestDataSource {
  //# shop-detail-controller (Guest)
  Future<SuccessResponse<int>> countShopFollowed(int shopId);
  Future<SuccessResponse<ShopDetailResp>> getShopDetailById(int shopId);

  //! location: ward-controller, province-controller, district-controller, ward-controller
  Future<SuccessResponse<List<ProvinceEntity>>> getProvinces();
  Future<SuccessResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode);
  Future<SuccessResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode);
  Future<SuccessResponse<FullAddressResp>> getFullAddressByWardCode(String wardCode);

  //# category-shop-guest-controller
  Future<SuccessResponse<List<CategoryShopEntity>>> getCategoryShopByShopId(int shopId);
  Future<SuccessResponse<CategoryShopEntity>> getCategoryShopByCategoryShopId(int categoryShopId);

  //# category-controller
  // GET
  // /api/category/all-parent
  // const String kAPIAllCategoryParentURL = '/category/all-parent'; // GET
  Future<SuccessResponse<List<CategoryEntity>>> getAllParentCategory();

  // GET
  // /api/category/all-category/by-parent/{categoryId}
  // const String kAPIAllCategoryByParentURL = '/category/all-category/by-parent'; // GET /{categoryId}
  Future<SuccessResponse<List<CategoryEntity>>> getAllCategoryByParent(int categoryId);
}

class GuestDataSourceImpl implements GuestDataSource {
  final Dio _dio;

  GuestDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<int>> countShopFollowed(int shopId) async {
    // OK:REVIEW why need accessToken here?
    final url = baseUri(path: '$kAPIShopCountFollowedURL/$shopId');
    final response = await _dio.getUri(
      url,
    );

    return handleDioResponse<int, int>(
      response,
      url,
      parse: (count) => count,
    );
  }

  @override
  Future<SuccessResponse<ShopDetailResp>> getShopDetailById(int shopId) async {
    final url = baseUri(path: '$kAPIShopURL/$shopId');

    final response = await _dio.getUri(url);

    return handleDioResponse<ShopDetailResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopDetailResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<List<ProvinceEntity>>> getProvinces() async {
    final url = baseUri(path: kAPILocationProvinceGetAllURL);
    final response = await _dio.getUri(
      url,
    );

    return handleDioResponse<List<ProvinceEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => (data['provinceDTOs'] as List<dynamic>)
          .map(
            (province) => ProvinceEntity.fromMap(province),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<FullAddressResp>> getFullAddressByWardCode(String wardCode) async {
    final url = baseUri(path: '$kAPILocationWardFullAddressURL/$wardCode');
    final response = await _dio.getUri(
      url,
    );

    return handleDioResponse<FullAddressResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => FullAddressResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode) async {
    final url = baseUri(path: '$kAPILocationWardGetAllByDistrictCodeURL/$districtCode');
    final response = await _dio.getUri(
      url,
    );

    return handleDioResponse<List<WardEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => (data['wardDTOs'] as List<dynamic>)
          .map(
            (ward) => WardEntity.fromMap(ward),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode) async {
    final url = baseUri(path: '$kAPILocationDistrictGetAllByProvinceCodeURL/$provinceCode');
    final response = await _dio.getUri(
      url,
    );

    return handleDioResponse<List<DistrictEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => (data['districtDTOs'] as List<dynamic>)
          .map(
            (district) => DistrictEntity.fromMap(district),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<CategoryShopEntity>> getCategoryShopByCategoryShopId(int categoryShopId) async {
    final url = baseUri(path: '$kAPICategoryShopByCategoryShopIdURL/$categoryShopId');

    final response = await _dio.getUri(url);

    return handleDioResponse<CategoryShopEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => CategoryShopEntity.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<List<CategoryShopEntity>>> getCategoryShopByShopId(int shopId) async {
    final url = baseUri(path: '$kAPICategoryShopByShopIdURL/$shopId');

    final response = await _dio.getUri(url);

    return handleDioResponse<List<CategoryShopEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['categoryShopDTOs'] as List<dynamic>)
          .map(
            (categoryShop) => CategoryShopEntity.fromMap(categoryShop),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<List<CategoryEntity>>> getAllCategoryByParent(int categoryId) async {
    final url = baseUri(path: '$kAPIAllCategoryByParentURL/$categoryId');

    final response = await _dio.getUri(url);

    return handleDioResponse<List<CategoryEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['categoryDTOs'] as List<dynamic>)
          .map(
            (category) => CategoryEntity.fromMap(category),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<List<CategoryEntity>>> getAllParentCategory() async {
    final url = baseUri(path: kAPIAllCategoryParentURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<List<CategoryEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['categoryDTOs'] as List<dynamic>)
          .map(
            (category) => CategoryEntity.fromMap(category),
          )
          .toList(),
    );
  }
}
