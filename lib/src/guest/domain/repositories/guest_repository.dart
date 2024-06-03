import '../../../core/constants/typedef.dart';
import '../../../home/domain/entities/dto/product_detail_resp.dart';
import '../../../home/domain/entities/dto/product_page_resp.dart';
import '../../../order/domain/entities/shipping_entity.dart';
import '../../../profile/domain/domain.dart';
import '../../../shop/domain/entities/shop_category_entity.dart';
import '../../../shop/domain/entities/dto/shop_detail_resp.dart';

abstract class GuestRepository {
  //# shop-detail-controller (Guest)
  FRespData<int> countShopFollowed(int shopId);
  FRespData<ShopDetailResp> getShopDetailById(int shopId);

  //! location: ward-controller, province-controller, district-controller, ward-controller
  FRespData<List<ProvinceEntity>> getProvinces();
  FRespData<List<DistrictEntity>> getDistrictsByProvinceCode(String provinceCode);
  FRespData<List<WardEntity>> getWardsByDistrictCode(String districtCode);
  FRespData<String> getFullAddressByWardCode(String wardCode);

  //# category-shop-guest-controller
  FRespData<List<ShopCategoryEntity>> getCategoryShopByShopId(int shopId);

  /// contains product list in this category shop
  FRespData<ShopCategoryEntity> getCategoryShopByCategoryShopId(int categoryShopId);

  //# product-controller
  // FRespData<ProductPageResp> getProductsByCategory(int page, int size, int categoryId); //>> product-page-controller
  FRespData<ProductDetailResp> getProductDetailById(int productId);
  FRespData<int> getProductCountFavorite(int productId);

  //# product-page-controller
  FRespData<ProductPageResp> getProductPageByCategory(int page, int size, int categoryId);

  //# shipping-controller
  FRespData<List<ShippingEntity>> getTransportProviders(String wardCodeCustomer, String wardCodeShop);
  FRespData<ShippingEntity> getCalculateShipping(String wardCodeCustomer, String wardCodeShop, String shippingProvider);
}
