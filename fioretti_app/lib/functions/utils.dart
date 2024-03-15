import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importeer de intl library

String minuteToString(int minuut) {
  return minuut < 10 ? "0$minuut" : "$minuut";
}

String dateTimeToString(DateTime dateTime) {
  // Gebruik DateFormat van intl om de datum inclusief weekdag te formatteren
  final formatter = DateFormat('EEEE, d MMMM y', 'nl_NL'); // Voor Nederlandse format, pas 'nl_NL' aan naar je locale indien nodig
  return formatter.format(dateTime) + " ${dateTime.hour}:${minuteToString(dateTime.minute)}";
}

String dateToString(DateTime datum) {
  final formatter = DateFormat('EEEE, d MMMM y', 'nl_NL'); // Voor Nederlandse format
  return formatter.format(datum);
}

String timeToString(DateTime tijd) {
  return "${tijd.hour}:${minuteToString(tijd.minute)}";
}

String getErrorMessageFromBody(dynamic body) {
  try {
    Map<String, dynamic> json = jsonDecode(body);
    if (json.containsKey("message") && json["message"] is String) {
      return json["message"];
    }
  } catch (e) {
    // Voeg een catch block toe voor het geval jsonDecode faalt
    print("Error parsing JSON: $e");
  }

  if (body is String) {
    return body;
  }
  return "";
}

// void showSnackBar(String bericht) {
//   final currentState = scaffoldMessengerKey.currentState;
//   if (currentState != null) {
//     currentState.showSnackBar(SnackBar(
//       content: Text(bericht),
//       duration: const Duration(seconds: 10),
//     ));
//   }
// }



