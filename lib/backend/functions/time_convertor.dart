String convertTime(DateTime data) {
  DateTime currentDate = DateTime.now();

  Duration difference = currentDate.difference(data);

  int minutes = difference.inMinutes;
  int hours = difference.inHours;
  int days = difference.inDays;
  int weeks = days ~/ 7;

  if (weeks > 0) {
    return '${weeks}w';
  } else if (days > 0) {
    return '${days}d';
  } else if (hours > 0) {
    return '${hours}h';
  } else {
    return '${minutes}m';
  }
}
