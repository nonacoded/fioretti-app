import 'package:fioretti_app/models/school_event.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:requests/requests.dart';

class EventPage extends StatefulWidget {
  final String id;

  const EventPage({super.key, required this.id});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  SchoolEvent? event;

  @override
  void initState() {
    super.initState();

    fetchEvent(widget.id).then((event) {
      setState(() {
        this.event = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: event == null ? "Bezig met laden..." : event!.title,
      body: Center(
        child: event == null
            ? const Text("Bezig met laden...")
            : Column(
                children: [
                  Text(event!.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                  Text(event!.description),
                  Text(event!.date),
                  ElevatedButton(
                    onPressed: () {
                      buyTicket(event!.id);
                    },
                    child: const Text("Koop ticket"),
                  )
                ],
              ),
      ),
    );
  }
}

void buyTicket(String eventId) async {
  final response =
      await Requests.post("${dotenv.env['API_URL']!}/events/$eventId/tickets");
  if (response.statusCode == 200) {
    print("Ticket gekocht!");
  } else {
    print("Ticket kopen mislukt! [${response.statusCode}] ${response.body}");
  }
}
