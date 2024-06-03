import 'package:dio/dio.dart';

import '../../../core/constants/api.dart';
import '../../../core/network/network.dart';
import '../../../home/domain/entities/category_entity.dart';
import '../../../home/domain/entities/dto/product_detail_resp.dart';
import '../../../home/domain/entities/dto/product_page_resp.dart';
import '../../../order/domain/entities/shipping_entity.dart';
import '../../../profile/domain/entities/entities.dart';
import '../../../shop/domain/entities/shop_category_entity.dart';
import '../../../shop/domain/entities/dto/shop_detail_resp.dart';

abstract class GuestDataSource {
  //# shop-detail-controller (Guest)
  Future<SuccessResponse<int>> countShopFollowed(int shopId);
  Future<SuccessResponse<ShopDetailResp>> getShopDetailById(int shopId);

  //# location: ward-controller, province-controller, district-controller, ward-controller
  Future<SuccessResponse<List<ProvinceEntity>>> getProvinces();
  Future<SuccessResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode);
  Future<SuccessResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode);
  Future<SuccessResponse<FullAddressResp>> getFullAddressByWardCode(String wardCode);

  //# category-shop-guest-controller
  Future<SuccessResponse<List<ShopCategoryEntity>>> getCategoryShopByShopId(int shopId);
  Future<SuccessResponse<ShopCategoryEntity>> getCategoryShopByCategoryShopId(int categoryShopId);

  //# category-controller
  Future<SuccessResponse<List<CategoryEntity>>> getAllParentCategory();
  Future<SuccessResponse<List<CategoryEntity>>> getAllCategoryByParent(int categoryId);

  //# product-controller
  Future<SuccessResponse<ProductDetailResp>> getProductDetailById(int productId);
  Future<SuccessResponse<int>> getProductCountFavorite(int productId);

  //# product-page-controller
  Future<SuccessResponse<ProductPageResp>> getProductPageByCategory(int page, int size, int categoryId);

  Future<SuccessResponse<ShippingEntity>> getCalculateShipping(
      String wardCodeCustomer, String wardCodeShop, String shippingProvider);
  Future<SuccessResponse<List<ShippingEntity>>> getTransportProviders(String wardCodeCustomer, String wardCodeShop);
}

class GuestDataSourceImpl implements GuestDataSource {
  final Dio _dio;

  GuestDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<int>> countShopFollowed(int shopId) async {
    // OK:REVIEW why need accessToken here?
    final url = uriBuilder(path: '$kAPIShopCountFollowedURL/$shopId');
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
    final url = uriBuilder(path: '$kAPIShopURL/$shopId');

    final response = await _dio.getUri(url);

    return handleDioResponse<ShopDetailResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopDetailResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<List<ProvinceEntity>>> getProvinces() async {
    final url = uriBuilder(path: kAPILocationProvinceGetAllURL);
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
    final url = uriBuilder(path: '$kAPILocationWardFullAddressURL/$wardCode');
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
    final url = uriBuilder(path: '$kAPILocationWardGetAllByDistrictCodeURL/$districtCode');
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
    final url = uriBuilder(path: '$kAPILocationDistrictGetAllByProvinceCodeURL/$provinceCode');
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
  Future<SuccessResponse<ShopCategoryEntity>> getCategoryShopByCategoryShopId(int categoryShopId) async {
    final url = uriBuilder(path: '$kAPICategoryShopByCategoryShopIdURL/$categoryShopId');

    final response = await _dio.getUri(url);

    return handleDioResponse<ShopCategoryEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopCategoryEntity.fromMap(jsonMap['categoryShopDTO']),
    );
  }

  @override
  Future<SuccessResponse<List<ShopCategoryEntity>>> getCategoryShopByShopId(int shopId) async {
    final url = uriBuilder(path: '$kAPICategoryShopByShopIdURL/$shopId');

    final response = await _dio.getUri(url);

    return handleDioResponse<List<ShopCategoryEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['categoryShopDTOs'] as List<dynamic>)
          .map(
            (categoryShop) => ShopCategoryEntity.fromMap(categoryShop),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<List<CategoryEntity>>> getAllCategoryByParent(int categoryId) async {
    final url = uriBuilder(path: '$kAPIAllCategoryByParentURL/$categoryId');

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
    final url = uriBuilder(path: kAPIAllCategoryParentURL);

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
  Future<SuccessResponse<ProductDetailResp>> getProductDetailById(int productId) async {
    final url = uriBuilder(path: '$kAPIProductDetailURL/$productId');
    final response = await _dio.getUri(url);

    return handleDioResponse<ProductDetailResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductDetailResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<int>> getProductCountFavorite(int productId) async {
    final url = uriBuilder(path: '$kAPIProductCountFavoriteURL/$productId');

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
  Future<SuccessResponse<ProductPageResp>> getProductPageByCategory(int page, int size, int categoryId) async {
    final url = uriBuilder(
      path: kAPIProductPageCategoryURL,
      pathVariables: {'categoryId': categoryId.toString()},
      queryParameters: {
        'page': page,
        'size': size,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
    final response = await _dio.getUri(url);

    return handleDioResponse<ProductPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ShippingEntity>> getCalculateShipping(
      String wardCodeCustomer, String wardCodeShop, String shippingProvider) async {
    final url = uriBuilder(
      path: kAPIShippingCalculateShippingURL,
      queryParameters: {
        'wardCodeCustomer': wardCodeCustomer,
        'wardCodeShop': wardCodeShop,
        'shippingProvider': shippingProvider,
      },
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<ShippingEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShippingEntity.fromMap(jsonMap['shippingDTO']),
    );
  }

  @override
  Future<SuccessResponse<List<ShippingEntity>>> getTransportProviders(
      String wardCodeCustomer, String wardCodeShop) async {
    final url = uriBuilder(
      path: kAPIShippingTransportProvidersURL,
      queryParameters: {
        'wardCodeCustomer': wardCodeCustomer,
        'wardCodeShop': wardCodeShop,
      },
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<List<ShippingEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['shippingDTOs'] as List<dynamic>)
          .map(
            (shipping) => ShippingEntity.fromMap(shipping),
          )
          .toList(),
    );
  }
}
