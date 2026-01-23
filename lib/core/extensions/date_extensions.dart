import 'package:intl/intl.dart';

// DateTime extensions
extension DateTimeExtensions on DateTime {
  // Format as "2 hours ago", "3 days ago", etc.
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  // Format as "Jan 23, 2026"
  String get formatted {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  // Format as "January 23, 2026"
  String get formattedLong {
    return DateFormat('MMMM dd, yyyy').format(this);
  }

  // Format with time
  String get formattedWithTime {
    return DateFormat('MMM dd, yyyy h:mm a').format(this);
  }

  // Check if today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  // Check if this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  // Start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // End of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }
}
