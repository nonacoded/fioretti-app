import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fioretti_app/main.dart';

String minuutNaarString(int minuut) {
  return minuut < 10 ? "0$minuut" : "$minuut";
}

String datumTijdNaarString(DateTime datumTijd) {
  final format = DateFormat('EEEE, d MMMM y', 'nl_NL'); // Voor Nederlandse datums
  return "${format.format(datumTijd)} ${datumTijd.hour}:${minuutNaarString(datumTijd.minute)}";
}

String datumNaarString(DateTime datum) {
  final format = DateFormat('EEEE, d MMMM y', 'nl_NL'); // Voor Nederlandse datums
  return format.format(datum);
}

String tijdNaarString(DateTime tijd) {
  return "${tijd.hour}:${minuutNaarString(tijd.minute)}";
}

String foutMeldingUitBody(dynamic body) {
  try {
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (json.containsKey('message') && json['message'] is String) {
      return json['message'];
    }
  } catch (_) {}
  return body is String ? body : '';
}

void toonSnackBar(String bericht) {
  final snackBar = SnackBar(
    content: Text(bericht),
    duration: const Duration(seconds: 10),
  );

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}



