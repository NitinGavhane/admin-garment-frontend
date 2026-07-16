import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  Function()? onUnauthorized;
  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  bool _tokensLoaded = false;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.timeout,
        receiveTimeout: ApiConfig.timeout,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              final retryResponse = await _retry(error.requestOptions);
              handler.resolve(retryResponse);
              return;
            }
            onUnauthorized?.call();
          }
          if (error.type == DioExceptionType.connectionError || error.type == DioExceptionType.connectionTimeout) {
            debugPrint('[API] Connection error');
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getAccessToken() async {
    if (_tokensLoaded) return _cachedAccessToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedAccessToken = prefs.getString('admin_access_token');
    _cachedRefreshToken = prefs.getString('admin_refresh_token');
    _tokensLoaded = true;
    return _cachedAccessToken;
  }

  Future<bool> _tryRefreshToken() async {
    try {
      if (_cachedRefreshToken == null) {
        final prefs = await SharedPreferences.getInstance();
        _cachedRefreshToken = prefs.getString('admin_refresh_token');
      }
      if (_cachedRefreshToken == null) return false;

      final response = await Dio(
        BaseOptions(baseUrl: ApiConfig.baseUrl),
      ).post(
        ApiConfig.refreshToken,
        data: {'refresh_token': _cachedRefreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _cachedAccessToken = data['access_token'] as String;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_access_token', _cachedAccessToken!);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await _getAccessToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
    );
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) {
    return _dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }

  Future<void> setTokens(String access, String refresh) async {
    _cachedAccessToken = access;
    _cachedRefreshToken = refresh;
    _tokensLoaded = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_access_token', access);
    await prefs.setString('admin_refresh_token', refresh);
  }

  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _tokensLoaded = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_access_token');
    await prefs.remove('admin_refresh_token');
  }

  Future<String?> getAccessToken() => _getAccessToken();

  Future<String> uploadFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filePath.split(r'\').last.split('/').last),
    });
    final response = await _dio.post(ApiConfig.upload, data: formData);
    return response.data['url'] as String;
  }

  // Web-safe upload: the admin app runs on Flutter web where file paths are not
  // available, so images are sent as raw bytes from the image picker.
  Future<String> uploadBytes(Uint8List bytes, String filename) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    final response = await _dio.post(ApiConfig.upload, data: formData);
    return response.data['url'] as String;
  }
}
