import 'package:intl/intl.dart' as intl;
String formattedDate(String dateString) {
  // Convert the string to a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Format it to show only Year-Month-Day
  String formattedDate = intl.DateFormat('yyyy-MM-dd').format(dateTime);

  return formattedDate; // Output: 1990-03-05
}