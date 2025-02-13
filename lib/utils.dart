import 'package:intl/intl.dart';

String capitalize(String value) =>
    value[0].toUpperCase() + value.substring(1).toLowerCase();

String formatDate(String? inputDate) {
  if (inputDate == null || inputDate.isEmpty) {
    return "Unknown";
  }

  try {
    DateTime date = DateTime.parse(inputDate);
    String daySuffix = getDaySuffix(date.day);
    return DateFormat("EEE, d'$daySuffix' MMM yyyy").format(date);
  } catch (e) {
    return "Unknown";
  }
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return "th";
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}
