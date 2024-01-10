String minuteToString(int minute) {
  if (minute < 10) {
    return "0$minute";
  } else {
    return "$minute";
  }
}

String dateTimeToString(DateTime dateTime) {
  return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${minuteToString(dateTime.minute)}";
}
