import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility functions and extensions for the application
class AppUtils {
  const AppUtils._();

  /// Format date to readable string
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format time to readable string
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }

  /// Format date and time to readable string
  static String formatDateTime(DateTime dateTime, {String format = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }

  /// Get relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone number format
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-()]{10,}$').hasMatch(phone);
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Get initials from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Show info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Get device screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final screenSize = getScreenSize(context);
    return screenSize.width > 600;
  }

  /// Check if device is phone
  static bool isPhone(BuildContext context) {
    return !isTablet(context);
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    }
    return const EdgeInsets.all(16.0);
  }

  /// Get responsive font size based on screen size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isTablet(context)) {
      return baseSize * 1.2;
    }
    return baseSize;
  }
}

/// Extension on String for common operations
extension StringExtension on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is valid email
  bool get isValidEmail => AppUtils.isValidEmail(this);

  /// Check if string is valid phone
  bool get isValidPhone => AppUtils.isValidPhone(this);

  /// Get initials from name
  String get initials => AppUtils.getInitials(this);

  /// Truncate text with ellipsis
  String truncate(int maxLength) => AppUtils.truncateText(this, maxLength);
}

/// Extension on DateTime for common operations
extension DateTimeExtension on DateTime {
  /// Format date to readable string
  String format({String format = 'MMM dd, yyyy'}) => AppUtils.formatDate(this, format: format);

  /// Format time to readable string
  String formatTime({String format = 'HH:mm'}) => AppUtils.formatTime(this, format: format);

  /// Format date and time to readable string
  String formatDateTime({String format = 'MMM dd, yyyy HH:mm'}) => AppUtils.formatDateTime(this, format: format);

  /// Get relative time string
  String get relativeTime => AppUtils.getRelativeTime(this);

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }
}

/// Extension on BuildContext for common operations
extension BuildContextExtension on BuildContext {
  /// Get screen size
  Size get screenSize => AppUtils.getScreenSize(this);

  /// Check if device is tablet
  bool get isTablet => AppUtils.isTablet(this);

  /// Check if device is phone
  bool get isPhone => AppUtils.isPhone(this);

  /// Get responsive padding
  EdgeInsets get responsivePadding => AppUtils.getResponsivePadding(this);

  /// Get responsive font size
  double responsiveFontSize(double baseSize) => AppUtils.getResponsiveFontSize(this, baseSize);

  /// Show success snackbar
  void showSuccessSnackBar(String message) => AppUtils.showSuccessSnackBar(this, message);

  /// Show error snackbar
  void showErrorSnackBar(String message) => AppUtils.showErrorSnackBar(this, message);

  /// Show info snackbar
  void showInfoSnackBar(String message) => AppUtils.showInfoSnackBar(this, message);

  /// Show confirmation dialog
  Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) => AppUtils.showConfirmationDialog(
    this,
    title: title,
    message: message,
    confirmText: confirmText,
    cancelText: cancelText,
  );
} 