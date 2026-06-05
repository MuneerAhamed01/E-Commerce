/// Firestore collection and subcollection path constants.
abstract final class FirestorePaths {
  static const users = 'users';
  static const products = 'products';
  static const categories = 'categories';
  static const brands = 'brands';
  static const banners = 'banners';
  static const carts = 'carts';
  static const orders = 'orders';
  static const reviews = 'reviews';
  static const coupons = 'coupons';
  static const notifications = 'notifications';

  static String user(String userId) => '$users/$userId';
  static String userAddresses(String userId) => '${user(userId)}/addresses';
  static String cartItems(String userId) => '$carts/$userId/items';
  static String productReviews(String productId) =>
      '$products/$productId/reviews';
}

/// Cloud Storage path prefixes.
abstract final class StoragePaths {
  static const products = 'products';
  static const categories = 'categories';
  static const brands = 'brands';
  static const banners = 'banners';
  static const users = 'users';

  static String userProfile(String userId) => '$users/$userId/profile';
  static String productImage(String productId) => '$products/$productId';
}
