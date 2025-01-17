extension DatetimeExtension on DateTime {
  String get format {
    return "${day < 10 ? "0$day" : day}.${month < 10 ? "0$month" : month}.$year";
  }
}
