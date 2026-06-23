import '../config/api_config.dart';
import '../models/dashboard.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../models/coupon.dart';
import 'api_service.dart';

class AdminService {
  final ApiService _api;

  AdminService(this._api);

  Future<void> login(String email, String password) async {
    final response = await _api.post(
      ApiConfig.adminLogin,
      data: {'email': email, 'password': password},
    );
    final data = response.data;
    await _api.setTokens(data['access_token'], data['refresh_token']);
  }

  Future<DashboardStats> getDashboard() async {
    final response = await _api.get(ApiConfig.adminDashboard);
    return DashboardStats.fromJson(response.data);
  }

  Future<List<AdminUser>> getUsers() async {
    final response = await _api.get(ApiConfig.adminUsers);
    final List<dynamic> data = response.data is List
        ? response.data
        : (response.data['users'] ?? []);
    return data
        .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Products
  Future<List<AdminProduct>> getProducts({
    String? category,
    String? search,
    String? sort,
    String? gender,
  }) async {
    final params = <String, dynamic>{};
    if (category != null) params['category'] = category;
    if (search != null) params['search'] = search;
    if (sort != null) params['sort'] = sort;
    if (gender != null) params['gender'] = gender;

    final response = await _api.get(
      ApiConfig.products,
      queryParams: params.isNotEmpty ? params : null,
    );
    final List<dynamic> data = response.data is List
        ? response.data
        : (response.data['products'] ?? []);
    return data
        .map((e) => AdminProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AdminProduct> getProduct(String id) async {
    final response = await _api.get('${ApiConfig.products}/$id');
    return AdminProduct.fromJson(response.data);
  }

  Future<AdminProduct> createProduct(Map<String, dynamic> data) async {
    final response = await _api.post(ApiConfig.adminProducts, data: data);
    return AdminProduct.fromJson(response.data);
  }

  Future<AdminProduct> updateProduct(
      String id, Map<String, dynamic> data) async {
    final response = await _api.put(ApiConfig.adminProduct(id), data: data);
    return AdminProduct.fromJson(response.data);
  }

  Future<void> deleteProduct(String id) async {
    await _api.delete(ApiConfig.adminProduct(id));
  }

  // Categories
  Future<List<AdminCategory>> getCategories({String? gender}) async {
    final params = <String, dynamic>{};
    if (gender != null) params['gender'] = gender;

    try {
      final response = await _api.get(
        ApiConfig.adminCategories,
        queryParams: params.isNotEmpty ? params : null,
      );
      final List<dynamic> data = response.data is List
          ? response.data
          : (response.data['categories'] ?? response.data['data'] ?? []);
      if (data.isNotEmpty) {
        return data
            .map((e) => AdminCategory.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    final response = await _api.get(
      ApiConfig.categories,
      queryParams: params.isNotEmpty ? params : null,
    );
    final List<dynamic> data = response.data is List
        ? response.data
        : (response.data['categories'] ?? []);
    return data
        .map((e) => AdminCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AdminCategory> getCategory(String id) async {
    final response = await _api.get(ApiConfig.adminCategory(id));
    return AdminCategory.fromJson(response.data);
  }

  Future<AdminCategory> createCategory(Map<String, dynamic> data) async {
    final response = await _api.post(ApiConfig.adminCategories, data: data);
    return AdminCategory.fromJson(response.data);
  }

  Future<AdminCategory> updateCategory(
      String id, Map<String, dynamic> data) async {
    final response =
        await _api.put(ApiConfig.adminCategory(id), data: data);
    return AdminCategory.fromJson(response.data);
  }

  Future<void> deleteCategory(String id) async {
    await _api.delete(ApiConfig.adminCategory(id));
  }

  // Orders
  Future<List<AdminOrder>> getOrders() async {
    final response = await _api.get(ApiConfig.adminOrders);
    final List<dynamic> data = response.data is List
        ? response.data
        : (response.data['orders'] ?? []);
    return data
        .map((e) => AdminOrder.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _api.put(
      ApiConfig.adminOrderStatus(orderId),
      data: {'status': status},
    );
  }

  // Coupons
  Future<List<AdminCoupon>> getCoupons() async {
    final response = await _api.get(ApiConfig.adminCoupons);
    final List<dynamic> data = response.data is List
        ? response.data
        : (response.data['coupons'] ?? []);
    return data
        .map((e) => AdminCoupon.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AdminCoupon> getCoupon(String id) async {
    final response = await _api.get(ApiConfig.adminCoupon(id));
    return AdminCoupon.fromJson(response.data);
  }

  Future<AdminCoupon> createCoupon(Map<String, dynamic> data) async {
    final response = await _api.post(ApiConfig.adminCoupons, data: data);
    return AdminCoupon.fromJson(response.data);
  }

  Future<AdminCoupon> updateCoupon(
      String id, Map<String, dynamic> data) async {
    final response = await _api.put(ApiConfig.adminCoupon(id), data: data);
    return AdminCoupon.fromJson(response.data);
  }

  Future<void> deleteCoupon(String id) async {
    await _api.delete(ApiConfig.adminCoupon(id));
  }

  Future<String> uploadImage(String filePath) async {
    return _api.uploadFile(filePath);
  }
}
