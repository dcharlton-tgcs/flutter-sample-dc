import 'package:flutter/material.dart';

class AppUtils {
  static String? time;

  static DateTime get dateTimeNow {
    if (time == null) {
      return DateTime.now();
    } else {
      return DateTime.parse(time!);
    }
  }

  static DayPeriod get dayPeriod => TimeOfDay.fromDateTime(dateTimeNow).period;
}
