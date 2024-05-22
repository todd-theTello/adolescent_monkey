import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'objects.dart';

extension D on TimeOfDay? {
  String get toHHMMSS {
    if (isNull) {
      return '';
    }
    return '${this!.hour}:${this!.minute}';
  }
}

/// extensions on date time
extension T on DateTime? {
  /// returns a string formats of yMMMED on date
  String get yMMMEd => isNull ? '' : DateFormat.yMMMEd().format(this!);

  /// returns a string formats of yMMMED on date
  String get getMonthString => isNull ? '' : DateFormat.yMMM().format(this!);

  /// checks if provided date is today
  bool get isToday {
    final now = DateTime.now();
    return this!.year == now.year && this!.month == now.month && this!.day == now.day;
  }

  /// checks if provided date is yesterday
  bool get isYesterday {
    final now = DateTime.now();
    return this!.year == now.year && this!.month == now.month && this!.day == (now.day - 1);
  }

  String get dateTimeToString {
    final year = '${this!.year}';
    final month = this!.month.toString().padLeft(2, '0');
    final day = this!.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String get timeAgo {
    if (this!.isAfter(DateTime.now().subtract(const Duration(days: 5)))) {
      return Jiffy.parse(this!.toIso8601String()).fromNow().replaceAll('ago', '');
    } else {
      return yMMMEd;
    }
  }

  DateTime get yearMonthDay {
    return DateTime(this!.year, this!.month, this!.day);
  }

  DateTime get previousMonth {
    final newMonth = this!.month != 1 ? this!.month - 1 : 12;
    final newYear = this!.month != 1 ? this!.year : this!.year - 1;
    return DateTime(newYear, newMonth);
  }
}

extension DateRangeExtension on DateTimeRange {
  List<DateTime> get getMonths {
    final months = <DateTime>[];

    // Get the start and end month and year
    final startYear = start.year;
    final startMonth = start.month;
    final endYear = end.year;
    final endMonth = end.month;

    // Loop through the years and months between the start and end dates
    for (var year = startYear; year <= endYear; year++) {
      final start = (year == startYear) ? startMonth : 1;
      final end = (year == endYear) ? endMonth : 12;

      for (var month = start; month <= end; month++) {
        months.add(DateTime(year, month));
      }
    }

    return months;
  }

  List<DateTime> get getYears {
    final years = <DateTime>[];

    // Get the start and end month and year
    final startYear = start.year;
    final endYear = end.year;

    // Loop through the years and months between the start and end dates
    for (var year = startYear; year <= endYear; year++) {
      years.add(DateTime(year));
    }

    return years;
  }
}
