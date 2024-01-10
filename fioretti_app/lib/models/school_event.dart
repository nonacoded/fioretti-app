import "dart:convert";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:requests/requests.dart";

class SchoolEvent {
  final String id;
  final String title;
  final String description;
  final String date;
  final String location;
  final double price;

  const SchoolEvent(this.id, this.title, this.description, this.date,
      this.location, this.price);

  factory SchoolEvent.fromJson(Map<String, dynamic> json) {
    if (json['price'] is int) {
      json['price'] = json['price'].toDouble();
    }
    return SchoolEvent(
        json['_id'] as String,
        json['title'] as String,
        json['description'] as String,
        json['date'] as String,
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
    throw Exception('Failed to load events');
  }
}

Future<SchoolEvent> fetchEvent(String id) async {
  final response = await Requests.get("${dotenv.env['API_URL']!}/events/$id");
  if (response.statusCode == 200) {
    return SchoolEvent.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load event');
  }
}
