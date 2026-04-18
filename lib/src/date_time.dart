import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  static double get epochTimestamp =>
      DateTime.fromMillisecondsSinceEpoch(0).toUtc().timestamp;
  static double get nowTimestamp => DateTime.now().toUtc().timestamp;

  double get timestamp => millisecondsSinceEpoch / 1000;

  bool isSameDayAs(DateTime dateTime) {
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day;
  }

  bool isSameYearAs(DateTime dateTime) {
    return year == dateTime.year;
  }

  static String friendlyDate(double timestamp) {
    final dtLocal = DateTimeExtensions.fromTimestamp(timestamp).toLocal();
    final now = DateTime.now();

    if (dtLocal.isSameDayAs(now)) {
      // Same day: display time only
      return _dateFormatTimeOnly(dtLocal);
    } else if (dtLocal.isSameYearAs(now)) {
      // Same year: display month and day
      return _dateFormatMonthAndDay(dtLocal);
    } else {
      // Older: display year, month and day
      return _dateFormatYearMonthAndDay(dtLocal);
    }
  }

  static String friendlyDateTime(
    double timestamp, {
    required String Function(int) hoursAgo,
    required String Function(int) minutesAgo,
    required String Function(int) secondsAgo,
  }) =>
      '${friendlyDate(timestamp)}, ${friendlyTime(timestamp, hoursAgo: hoursAgo, minutesAgo: minutesAgo, secondsAgo: secondsAgo)}';

  static String friendlyDateTimeIso(
    String dateTimeIso, {
    required String Function(int) hoursAgo,
    required String Function(int) minutesAgo,
    required String Function(int) secondsAgo,
  }) {
    try {
      final utc = DateTime.parse(dateTimeIso);
      final local = utc.toLocal();
      return friendlyDateTime(
        local.timestamp,
        hoursAgo: hoursAgo,
        minutesAgo: minutesAgo,
        secondsAgo: secondsAgo,
      );
    } catch (_) {
      return dateTimeIso;
    }
  }

  static String friendlyTime(
    double timestamp, {
    required String Function(int) hoursAgo,
    required String Function(int) minutesAgo,
    required String Function(int) secondsAgo,
  }) {
    final dtLocal = DateTimeExtensions.fromTimestamp(timestamp).toLocal();
    var now = DateTime.now();

    if (dtLocal.isSameDayAs(now)) {
      final diff = now.difference(dtLocal);
      if (diff.inHours > 0) {
        return hoursAgo(diff.inHours);
      } else if (diff.inMinutes > 0) {
        return minutesAgo(diff.inMinutes);
      } else {
        return secondsAgo(diff.inSeconds);
      }
    } else {
      return _dateFormatTimeOnly(dtLocal);
    }
  }

  static DateTime fromTimestamp(double timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(
        (timestamp * 1000).round(),
        isUtc: true,
      );

  /// Returns a localized [String] with the right time unit (seconds, minutes,
  /// hours).
  ///
  /// For example if [milliseconds] is 2000, the returned value for an english
  /// locale would be "2 seconds".
  static String timeUnitFriendly(
    int milliseconds, {
    required String Function(int) numberOfSeconds,
    required String Function(int) numberOfMinutes,
    required String Function(int) numberOfHours,
  }) {
    final seconds = milliseconds ~/ 1000;
    final secondsAbs = seconds.abs();
    const oneMinute = 60;
    const oneHour = 60 * 60;

    if (secondsAbs < oneMinute) {
      // Seconds
      return numberOfSeconds(seconds);
    } else if (secondsAbs < oneHour) {
      // Minutes
      return numberOfMinutes(seconds ~/ oneMinute);
    } else {
      // Hours
      return numberOfHours(seconds ~/ oneHour);
    }
  }

  static String _dateFormatMonthAndDay(DateTime dt) {
    try {
      return DateFormat.MMMd().format(dt);
    } catch (_) {
      return DateFormat.MMMd('en_US').format(dt);
    }
  }

  static String _dateFormatTimeOnly(DateTime dt) {
    try {
      return DateFormat.jm().format(dt);
    } catch (_) {
      return DateFormat.jm('en_US').format(dt);
    }
  }

  static String _dateFormatYearMonthAndDay(DateTime dt) {
    try {
      return DateFormat.yMd().format(dt);
    } catch (_) {
      return DateFormat.yMd('en_US').format(dt);
    }
  }
}
