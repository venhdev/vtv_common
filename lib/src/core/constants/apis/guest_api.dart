part of '../api.dart';

//! Product APIs (Guest)
//# product-suggestion-controller
const String kAPISuggestionProductPageRandomlyURL = '/product-suggestion/get-page/randomly'; // GET
// GET /api/product-suggestion/get-page/randomly/product/{productId}
const String kAPISuggestionProductPageRandomlyByAlikeProductURL =
    '/product-suggestion/get-page/randomly/product'; // GET /{productId}

//# search-product-controller
const String kAPISearchProductSortURL = '/search/product/sort'; // GET --only keyword
const String kAPIGetSearchProductPriceRangeSortURL = '/search/product/price-range/sort'; // GET

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

//! Other APIs (Guest)
//# category-controller
const String kAPIAllCategoryURL = '/category/all-parent'; // GET

//# review-controller
const String kAPIReviewProductURL = '/review/product'; // GET /{productId}

//# shop-detail-controller
const String kAPIShopDetailCountFollowedURL = '/shop-detail/count-followed'; // GET /{shopId}