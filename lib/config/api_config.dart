class ApiConfig {
  static const String baseUrl = 'https://backend-1u38kak5s-gavhanenitin911gmailcoms-projects.vercel.app';
  static const String apiPrefix = '/api/v1';
  static const Duration timeout = Duration(seconds: 30);

  static const String adminLogin = '$apiPrefix/admin/login';
  static const String adminDashboard = '$apiPrefix/admin/dashboard';
  static const String adminUsers = '$apiPrefix/admin/users';
  static const String adminOrders = '$apiPrefix/admin/orders';
  static String adminOrderStatus(String id) => '$apiPrefix/admin/orders/$id/status';
  static const String adminProducts = '$apiPrefix/admin/products';
  static String adminProduct(String id) => '$apiPrefix/admin/products/$id';
  static const String adminCategories = '$apiPrefix/admin/categories';
  static String adminCategory(String id) => '$apiPrefix/admin/categories/$id';
  static const String adminCoupons = '$apiPrefix/admin/coupons';
  static String adminCoupon(String id) => '$apiPrefix/admin/coupons/$id';

  // Public endpoints (used for admin list/detail views)
  static const String products = '$apiPrefix/products';
  static const String categories = '$apiPrefix/categories';

  static const String upload = '$apiPrefix/upload';
  static const String refreshToken = '$apiPrefix/auth/refresh-token';
}
