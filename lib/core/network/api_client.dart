import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  // Base URL for your custom backend
  // In development, for Android emulator use 10.0.2.2, for iOS simulator use localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    // Add interceptors for logging, auth tokens, etc.
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    // Example: Add Auth Token Interceptor
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     // String? token = await _getToken();
    //     // if (token != null) {
    //     //   options.headers['Authorization'] = 'Bearer $token';
    //     // }
    //     return handler.next(options);
    //   },
    // ));
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST Request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE Request
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    String errorDescription = "";
    if (error.response != null) {
      errorDescription =
          "Error ${error.response!.statusCode}: ${error.response!.data}";
    } else {
      errorDescription = "Network Error: ${error.message}";
    }
    return Exception(errorDescription);
  }
}
