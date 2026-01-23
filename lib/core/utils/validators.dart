// Input validation helpers
class Validators {
  // Validate email
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate URL
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Validate not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  // Validate minimum length
  static bool hasMinLength(String? value, int minLength) {
    return value != null && value.length >= minLength;
  }

  // Validate maximum length
  static bool hasMaxLength(String? value, int maxLength) {
    return value != null && value.length <= maxLength;
  }

  // Validate range
  static bool isInRange(int value, int min, int max) {
    return value >= min && value <= max;
  }
}
