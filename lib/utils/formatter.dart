import 'package:intl/intl.dart';

class Formatter {
  static String currency(double amount, {bool compact = false}) {
    if (compact && amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    }
    if (compact && amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return f.format(amount);
  }

  static String date(DateTime d) => DateFormat('MMM d, yyyy').format(d);

  static String shortDate(DateTime d) => DateFormat('MMM d').format(d);

  static String time(DateTime d) => DateFormat('h:mm a').format(d);

  static String monthYear(DateTime d) => DateFormat('MMMM yyyy').format(d);

  static String dayLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(d.year, d.month, d.day);
    if (target == today) return 'Today';
    if (target == yesterday) return 'Yesterday';
    return DateFormat('MMMM d').format(d);
  }

  static String dayOfWeekShort(DateTime d) => DateFormat('EEE').format(d);

  static String monthShort(DateTime d) => DateFormat('MMM').format(d);
}
