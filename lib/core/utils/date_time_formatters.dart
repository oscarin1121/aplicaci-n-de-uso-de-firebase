import 'package:intl/intl.dart';

class DateTimeFormatters {
  const DateTimeFormatters._();

  static final DateFormat _shortDate = DateFormat('MMM d, y');
  static final DateFormat _compactDate = DateFormat('MMM d');
  static final DateFormat _timeStamp = DateFormat('MMM d • h:mm a');

  static String formatDate(DateTime date) => _shortDate.format(date);

  static String formatTimestamp(DateTime date) => _timeStamp.format(date);

  static String relativeUpdate(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inSeconds < 45) {
      return 'Updated just now';
    }
    if (diff.inMinutes < 60) {
      return 'Updated ${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return 'Updated ${diff.inHours}h ago';
    }
    if (diff.inDays == 1) {
      return 'Updated yesterday';
    }
    if (diff.inDays < 7) {
      return 'Updated ${diff.inDays}d ago';
    }

    return 'Updated ${_compactDate.format(date)}';
  }

  static String dueDateLabel(DateTime? dueDate) {
    if (dueDate == null) {
      return 'No deadline';
    }

    return _shortDate.format(dueDate);
  }

  static String dueDateHint(DateTime? dueDate) {
    if (dueDate == null) {
      return 'Define un deadline para dar prioridad visual.';
    }

    final DateTime today = DateTime.now();
    final DateTime normalizedToday = DateTime(
      today.year,
      today.month,
      today.day,
    );
    final DateTime normalizedDue = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
    );
    final int days = normalizedDue.difference(normalizedToday).inDays;

    if (days < 0) {
      final int overdueDays = days.abs();
      return overdueDays == 1
          ? 'Overdue by 1 day'
          : 'Overdue by $overdueDays days';
    }
    if (days == 0) {
      return 'Due today';
    }
    if (days == 1) {
      return '1 day remaining';
    }

    return '$days days remaining';
  }
}
