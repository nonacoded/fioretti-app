import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:fioretti_app/widgets/event_display.dart';
import 'package:flutter/material.dart';
import 'package:fioretti_app/models/ticket.dart';
import 'package:go_router/go_router.dart';

class TicketPage extends StatefulWidget {
  final String id;

  const TicketPage({super.key, required this.id});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  Ticket? ticket;
  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();

    fetchTicket(widget.id).then((ticket) {
      setState(() {
        this.ticket = ticket;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Gekochte ticket",
      body: Center(
        child: ticket == null
            ? (!finishedLoading
                ? const Text("Bezig met laden...")
                : const Text("Geen ticket gevonden"))
            : Column(
              //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EventDisplay(event: ticket!.event),
                  ElevatedButton(
                    onPressed: () {
                      context.push("/tickets/${ticket!.id}/qr", extra: ticket);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(5.0),
                              ),
              backgroundColor: Colors.lightBlue[900], // achtergrondkleur van de knop
              foregroundColor: Colors.white, // tekstkleur van de knop
            ),
                    child: const Text("Toon QR code"),
                  ),
                ],
              ),
      ),
    );
  }
}
