const List<String> _shortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatAppDateTime(DateTime dateTime) {
  final day = dateTime.day;
  final month = _shortMonths[dateTime.month - 1];
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$day $month, $hour:$minute';
}

String formatAppDate(DateTime dateTime) {
  final day = dateTime.day;
  final month = _shortMonths[dateTime.month - 1];
  final year = dateTime.year;
  return '$day $month $year';
}

String formatAppTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
