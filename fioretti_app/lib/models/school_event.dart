import "package:http/http.dart" as http;
import "dart:convert";

class SchoolEvent {
  final String _id;
  final String title;
  final String description;
  final String date;
  final String location;
  final int price;

  const SchoolEvent(this._id, this.title, this.description, this.date,
      this.location, this.price);

  factory SchoolEvent.fromJson(Map<String, dynamic> json) {
    return SchoolEvent(
        json['_id'] as String,
        json['title'] as String,
        json['description'] as String,
        json['date'] as String,
        json['location'] as String,
        json['price'] as int);
  }
}

Future<List<SchoolEvent>> fetchEvents() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/events'));
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
