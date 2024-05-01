import '../../../core/constants/typedef.dart';
import '../../../profile/domain/domain.dart';
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
}
