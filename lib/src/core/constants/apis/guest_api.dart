part of '../api.dart';

//! //*---------------------Product APIs (Guest)-----------------------*//
//# product-suggestion-controller
const String kAPISuggestionProductPageRandomlyURL = '/product-suggestion/get-page/randomly'; // GET
// GET /api/product-suggestion/get-page/randomly/product/{productId}
const String kAPISuggestionProductPageRandomlyByAlikeProductURL =
    '/product-suggestion/get-page/randomly/product'; // GET /{productId}

//# search-product-controller
const String kAPISearchProductSortURL = '/search/product/sort'; // GET --only keyword
const String kAPISearchProductPriceRangeSortURL = '/search/product/price-range/sort'; // GET
const String kAPISearchProductShopSortURL = '/search/product/shop/:shopId/sort'; // GET
const String kAPISearchProductShopPriceRangeSortURL = '/search/product/shop/:shopId/price-range/sort'; // GET

//# product-filter-controller
const String kAPIProductFilterURL = '/product-filter'; // GET /{filter}
const String kAPIProductFilterPriceRangeURL = '/product-filter/price-range'; // GET /{filter}

//# product-controller
const String kAPIProductDetailURL = '/product/detail'; // GET /{productId}
// const String kAPIProductShopURL = '/product/shop'; // GET /{shopId}
const String kAPIProductCountFavoriteURL = '/product/count-favorite'; // GET /{productId}

//# product-page-controller
const String kAPIProductPageCategoryURL = '/product/page/category'; // GET /{categoryId}
const String kAPIProductPageShopURL = '/product/page/shop'; // GET /{shopId}

//# category-shop-guest-controller
const String kAPICategoryShopByShopIdURL = '/category-shop/get-list/shop-id'; // GET /{shopId}
const String kAPICategoryShopByCategoryShopIdURL = '/category-shop/category-shop-id'; // GET /{categoryShopId}

//! //*---------------------SHOP APIs (Guest)-----------------------*//
//# shop-detail-controller
const String kAPIShopCountFollowedURL = '/shop/count-followed'; // GET /{shopId}
const String kAPIShopURL = '/shop'; // GET /{shopId} >? why not add /detail

//! //*---------------------Location APIs (Guest)-----------------------*//
// province-controller
const String kAPILocationProvinceGetAllURL = '/location/province/get-all'; // GET
// district-controller
const String kAPILocationDistrictGetAllByProvinceCodeURL =
    '/location/district/get-all-by-province-code'; // GET /{provinceCode}
// ward-controller
const String kAPILocationWardGetAllByDistrictCodeURL = '/location/ward/get-all-by-district-code'; // GET /{districtCode}
const String kAPILocationWardFullAddressURL = '/location/ward/full-address'; // GET /{wardCode}

//! //*---------------------Other APIs (Guest)-----------------------*//
//# category-controller
const String kAPIAllCategoryURL = '/category/all-parent'; // GET

//# review-controller
const String kAPIReviewProductURL = '/review/product'; // GET /{productId}
const String kAPIReviewDetailURL = '/review/detail'; // GET /{reviewId}

//# comment-controller
const String kAPICommentGetURL = '/comment/get'; // GET /{reviewId}

