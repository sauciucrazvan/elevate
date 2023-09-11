String convertTime(DateTime data) {
  DateTime currentDate = DateTime.now();

  Duration difference = currentDate.difference(data);

  int minutes = difference.inMinutes;
  int hours = difference.inHours;

  if (hours > 0) {
    return '${hours}h';
  } else {
    return '${minutes}m';
  }
}
