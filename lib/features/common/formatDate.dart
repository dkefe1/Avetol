import 'package:intl/intl.dart';

String formatDate(String date) {
  try {
    if (date.endsWith('Z')) {
      date = date.substring(0, date.length - 1);
    }
    DateTime dateTime = DateTime.parse(date).toLocal();
    String formattedDate = DateFormat('yyyy').format(dateTime);

    return formattedDate;
  } catch (e) {
    return "2002";
  }
}

int convertToMinutes(String time) {
  List<String> parts = time.split(":");
  if (parts.length != 3) {
    throw Exception(
        "Invalid time format. Expected format: 'hours:minutes:seconds'");
  }

  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  int totalMinutes = hours * 60 + minutes + (seconds >= 30 ? 1 : 0);

  return totalMinutes;
}

String formatDateWithoutTime(DateTime date) {
  String year = date.year.toString();
  String month =
      date.month.toString().padLeft(2, '0'); // Ensures two-digit month
  String day = date.day.toString().padLeft(2, '0'); // Ensures two-digit day

  return "$year-$month-$day";
}
