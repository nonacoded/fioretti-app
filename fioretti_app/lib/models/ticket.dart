import "dart:convert";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:requests/requests.dart";
import "package:fioretti_app/models/school_event.dart";

class Ticket {
  final String id;
  final String eventId;
  final String userId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final SchoolEvent event;

  const Ticket(this.id, this.eventId, this.userId, this.createdAt,
      this.expiresAt, this.event);

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      json['_id'] as String,
      json['eventId'] as String,
      json['userId'] as String,
      DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      DateTime.fromMillisecondsSinceEpoch(json['expiresAt']),
      SchoolEvent.fromJson(json['event'] as Map<String, dynamic>),
    );
  }
}

Future<List<Ticket>> fetchTickets() async {
  final response = await Requests.get("${dotenv.env['API_URL']!}/tickets");
  if (response.statusCode == 200) {
    List<dynamic> responseJson = jsonDecode(response.body);
    List<Ticket> tickets = [];
    for (int i = 0; i < responseJson.length; i++) {
      tickets.add(Ticket.fromJson(responseJson[i]));
    }
    return tickets;
  } else {
    throw Exception('Failed to load tickets');
  }
}

Future<Ticket?> fetchTicket(String id) async {
  final response = await Requests.get("${dotenv.env['API_URL']!}/tickets/$id");
  if (response.statusCode == 200) {
    return Ticket.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    return null;
  } else {
    throw Exception('Failed to load ticket ${response.body}');
  }
}

Future<Ticket?> fetchOwnTicketByEventId(String eventId) async {
  final response =
      await Requests.get("${dotenv.env['API_URL']!}/tickets?event=$eventId");
  if (response.statusCode == 200) {
    return Ticket.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    return null;
  } else {
    throw Exception('Failed to load ticket ${response.body}');
  }
}
