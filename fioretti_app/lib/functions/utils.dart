import 'dart:convert';
import 'package:fioretti_app/main.dart';
import 'package:flutter/material.dart';

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

String getErrorMessageFromBody(dynamic body) {
  try {
    Map<String, dynamic> json = jsonDecode(body);
    if (json.containsKey("message") && json["message"] is String) {
      return json["message"];
    }
  } finally {}

  if (body is String) {
    return body;
  }
  return "";
}

void showSnackBar(String message) {
  if (scaffoldMessengerKey.currentState != null) {
    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 10),
    ));
  }
}
