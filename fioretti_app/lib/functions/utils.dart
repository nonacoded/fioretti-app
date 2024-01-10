String minuteToString(int minute) {
  if (minute < 10) {
    return "0$minute";
  } else {
    return "$minute";
  }
}
