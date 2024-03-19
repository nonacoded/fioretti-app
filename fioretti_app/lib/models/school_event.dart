import "dart:convert";
import "package:fioretti_app/functions/utils.dart";
import "package:fioretti_app/widgets/scaffold.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:requests/requests.dart";

class SchoolEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  //final DateTime time;
  final String location;
  final double price;

  const SchoolEvent(this.id, this.title, this.description, this.date, //this.time,
      this.location, this.price);

  factory SchoolEvent.fromJson(Map<String, dynamic> json) {
    if (json['price'] is int) {
      json['price'] = json['price'].toDouble();
    }
    return SchoolEvent(
        json['_id'] as String,
        json['title'] as String,
        json['description'] as String,
        DateTime.fromMillisecondsSinceEpoch(json['date']),
       //DateTime.fromMillisecondsSinceEpoch(json['time']),
        json['location'] as String,
        json['price'] as double);
  }
}

Future<List<SchoolEvent>> fetchEvents() async {
  final response = await Requests.get("${dotenv.env['API_URL']!}/events");
  if (response.statusCode == 200) {
    List<dynamic> responseJson = jsonDecode(response.body);
    List<SchoolEvent> events = [];
    for (int i = 0; i < responseJson.length; i++) {
      events.add(SchoolEvent.fromJson(responseJson[i]));
    }
    return events;
  } else {
    var error =
        'Failed to load events: ${getErrorMessageFromBody(response.body)}';
    showSnackBar(error);
    throw Exception(error);
  }
}

Future<SchoolEvent?> fetchEvent(String id) async {
  final response = await Requests.get("${dotenv.env['API_URL']!}/events/$id");
  if (response.statusCode == 200) {
    return SchoolEvent.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    return null;
  } else {
    var error =
        "Failed to load event: ${getErrorMessageFromBody(response.body)}}";
    showSnackBar(error);
    throw Exception(error);
  }
}
