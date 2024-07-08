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

enum TypeWork {
  Unknown,
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

class SortType {
  static const String bestSelling = 'best-selling';
  static const String newest = 'newest';
  static const String priceAsc = 'price-asc';
  static const String priceDesc = 'price-desc';
  static const String random = 'random';
}

enum VoucherType {
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
  RETURNED, // đơn được yêu cầu trả lại
  REFUNDED, // đơn được đã được hoàn tiền
  DELIVERED, // đã giao ??? đang được giao


  // for vendor only
  UNPAID, // chưa thanh toán

  // for deliver only
  PICKED_UP,
  WAREHOUSE,
}

enum PaymentType {
  COD,
  VNPay,
  Wallet,
}

enum NotificationType {
  ORDER,
  NEW_MESSAGE,
}

//*---------------------Custom-----------------------*//
enum ActionType { add, update, delete, unknown }

enum LoadStatus { initial, loading, loaded, error }
