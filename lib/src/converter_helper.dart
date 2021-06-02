part of '../getxfire.dart';

class ConverterHelper {
  static Color hexToColor(String? code) {
    return code == null
        ? Colors.black54
        : Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}'.toUpperCase();
  }

  static String numberFormat(int number) {
    final formatter = new NumberFormat("#,###");
    return formatter.format(number);
  }

  static String? stringFormatYmd(String? date) {
    if (date == null)
      return null;
    else {
      var data = date.split("-");

      if (data.length < 3) data = date.split("/");
      if (data.length < 3) return null;

      var day = data[0];
      var month = data[1];
      var year = data[2];
      return "$year-$month-$day";
    }
  }

  static DateTime? dateFormatYmd(String? dateInput) {
    if (dateInput == null)
      return null;
    else {
      try {
        var date = dateInput.split(" ").first;
        var data = date.split("-");

        if (data.length < 3) data = date.split("/");
        if (data.length < 3) return null;

        var day = data[0];
        var month = data[1];
        var year = data[2];

        if (year.length < 4) return DateTime.parse(dateInput);

        return DateTime.parse("$year-$month-$day");
      } catch (e) {
        return null;
      }
    }
  }

  static String? stringFormatDmy(DateTime? date, [String? stringLocale]) {
    return date == null
        ? null
        : DateFormat("dd-MM-yyyy", stringLocale).format(date);
  }

  static String? stringFormatDmyHhMmA(DateTime? date, [String? stringLocale]) {
    return date == null
        ? null
        : DateFormat("dd-MM-yyyy, hh:mm a", stringLocale).format(date);
  }

  static String? stringFormatDmyHeader(DateTime? date, [String? stringLocale]) {
    return date == null
        ? null
        : DateFormat("EEEE, dd MMMM yyyy", stringLocale).format(date);
  }

  static DateTime? dateFormatYmdOnly(DateTime? date) {
    return date == null
        ? null
        : DateTime.parse(DateFormat("yyyy-MM-dd").format(date));
  }
}
