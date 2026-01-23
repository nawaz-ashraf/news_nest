// String extensions for common operations
extension StringExtensions on String {
  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // Truncate with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Check if string is a valid URL
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.isAbsolute;
    } catch (e) {
      return false;
    }
  }

  // Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  // Convert to title case
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  // Check if empty or null
  bool get isNullOrEmpty {
    return isEmpty;
  }

  // Extract domain from URL
  String? get domain {
    try {
      final uri = Uri.parse(this);
      return uri.host;
    } catch (e) {
      return null;
    }
  }
}

// Nullable string extensions
extension NullableStringExtensions on String? {
  // Check if null or empty
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  // Get value or default
  String orDefault(String defaultValue) {
    return this ?? defaultValue;
  }

  // Safe substring
  String? substring(int start, [int? end]) {
    if (this == null) return null;
    if (start < 0 || start >= this!.length) return null;
    return this!.substring(start, end);
  }
}
