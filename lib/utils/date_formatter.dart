String formatValidityDate(DateTime date) {
  String day = date.day.toString();
  String suffix;

  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }

  String month = _getMonthAbbreviation(date.month);

  return '$day$suffix $month';
}

String _getMonthAbbreviation(int month) {
  const List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  return months[month - 1];
}
