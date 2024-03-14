import 'package:fioretti_app/models/school_event.dart';
import 'package:fioretti_app/models/ticket.dart';
import 'package:fioretti_app/widgets/event_display.dart';
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
  bool finishedLoading = false;
  bool canClickBuyButton = false;
  bool boughtTicket = false;

  @override
  void initState() {
    super.initState();

    fetchEvent(widget.id).then((event) {
      setState(() {
        this.event = event;
        finishedLoading = true;
      });

      if (event != null) {
        fetchOwnTicketByEventId(event.id).then((ticket) {
          setState(() {
            canClickBuyButton = ticket == null;
            boughtTicket = ticket != null;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: event == null
          ? (!finishedLoading ? "Bezig met laden..." : "Evenement")
          : event!.title, //hier eigenlijk titel "Ticket kopen"
      body: /*Center(*/
        child: event == null
            ? Text(!finishedLoading
                ? "Bezig met laden..."
                : "Evenement niet gevonden")
            : Column(
                children: [
                  EventDisplay(event: event!),
                  ElevatedButton(
                    onPressed: !canClickBuyButton
                        ? null
                        : () {
                            buyTicket(event!.id);
                            setState(() {
                              boughtTicket = true;
                              canClickBuyButton = false;
                            });
                          },
                    child:
                        Text(!boughtTicket ? "Koop ticket" : "Ticket gekocht"),
                        style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue[900], // achtergrondkleur van de knop
              onPrimary: Colors.white, // tekstkleur van de knop
            ),
                  )
                ],
              ),
      ),
   /* );*/
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
