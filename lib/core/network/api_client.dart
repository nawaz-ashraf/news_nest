import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

// API Client using Dio
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        queryParameters: {
          'apikey': ApiConstants.apiKey,
          'country': ApiConstants.countryIndia,
          'language': ApiConstants.languageEnglish,
        },
      ),
    );

    // Add interceptors
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';

        if (statusCode == 401) {
          return UnauthorizedException('Invalid API key');
        } else if (statusCode == 404) {
          return NotFoundException('Resource not found');
        } else if (statusCode! >= 500) {
          return ServerException('Server error: $message');
        }
        return ApiException('Request failed: $message');

      case DioExceptionType.cancel:
        return ApiException('Request cancelled');

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return NoInternetException(
            'No internet connection. Please check your network settings.',
          );
        }
        return ApiException('Connection error');

      case DioExceptionType.badCertificate:
        return ApiException('Security certificate error');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NoInternetException(
            'No internet connection. Please check your network settings.',
          );
        }
        return ApiException('An unexpected error occurred');
    }
  }
}
