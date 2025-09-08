import 'package:intl/intl.dart';

/// Utility class for date formatting
class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd.MM.yy');

  /// Format date only
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format time only
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Format short date
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format relative time (e.g., "vor 5 Minuten")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return 'vor ${difference.inDays} Tag${difference.inDays > 1 ? 'en' : ''}';
    } else if (difference.inHours > 0) {
      return 'vor ${difference.inHours} Stunde${difference.inHours > 1 ? 'n' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'vor ${difference.inMinutes} Minute${difference.inMinutes > 1 ? 'n' : ''}';
    } else {
      return 'gerade eben';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}
