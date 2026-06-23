import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';

class AdminAuthProvider extends ChangeNotifier {
  final AdminService _adminService;
  final ApiService _apiService;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  AdminAuthProvider(this._adminService, this._apiService);

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;

  set onUnauthorized(Function() callback) {
    _apiService.onUnauthorized = callback;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _adminService.login(email, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _extractError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkAuth() async {
    final token = await _apiService.getAccessToken();
    if (token == null) return false;
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _apiService.clearTokens();
    _isAuthenticated = false;
    notifyListeners();
  }

  String _extractError(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          final first = detail.first;
          if (first is Map && first.containsKey('msg')) return first['msg'];
        }
      }
      if (e.response?.statusCode == 401) return 'Invalid admin credentials';
      if (e.response?.statusCode == 403) return 'Access denied. Admin only.';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Connection timed out. Check your network.';
      }
      if (e.type == DioExceptionType.connectionError) {
        return 'No internet connection.';
      }
    }
    return 'Login failed. Please try again.';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
