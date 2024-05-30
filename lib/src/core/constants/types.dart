// ignore_for_file: constant_identifier_names
enum Role {
  CUSTOMER,
  VENDOR,
  ADMIN,
  PROVIDER,
  DELIVER,
  MANAGER,
  MANAGERCUSTOMER,
  MANAGERVENDOR,
  MANAGERSHIPPING,
  DELIVER_MANAGER
}

enum TypeWorks {
  SHIPPER,
  PROVIDER,
  MANAGER,
  WAREHOUSE,
  TRANSIT,
  PICKUP,
}

enum Status {
  ACTIVE,
  INACTIVE,
  DELETED,
  CANCEL,
  LOCKED,
}

class SortTypes {
  static const String bestSelling = 'best-selling';
  static const String newest = 'newest';
  static const String priceAsc = 'price-asc';
  static const String priceDesc = 'price-desc';
  static const String random = 'random';
}

enum VoucherTypes {
  PERCENTAGE_SHOP,
  PERCENTAGE_SYSTEM,
  MONEY_SHOP,
  MONEY_SYSTEM,
  // FIXED_SHOP,
  // SHIPPING,
}

enum OrderStatus {
  // all roles
  WAITING, // chờ xác nhận từ shop (khi hủy)
  PENDING, // chờ xác nhận từ shop (khi mới đặt)
  PICKUP_PENDING, // chờ shipper lấy hàng
  SHIPPING, // đang giao
  COMPLETED, // hoàn thành
  PROCESSING,
  CANCEL, // đơn đã hủy
  DELIVERED, // đã giao ??? đang được giaoC

  // for vendor only
  UNPAID, // chưa thanh toán

  // for deliver only
  PICKED_UP,
  WAREHOUSE,
}

enum PaymentTypes {
  COD,
  VNPay,
  Wallet,
}

enum ActionTypes { add, update, delete, unknown }
