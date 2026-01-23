// API Configuration Constants
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://newsdata.io/api/1';

  // API Key - TODO: Replace with your actual API key or use environment variables
  static const String apiKey = 'pub_a7b313ca7b2b4870ab495e38622b0059';

  // Endpoints
  static const String newsEndpoint = '/news';
  static const String latestNewsEndpoint = '/latest';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration cacheValidity = Duration(hours: 4);

  // Query parameters
  static const String countryIndia = 'in';
  static const String languageEnglish = 'en';
}
