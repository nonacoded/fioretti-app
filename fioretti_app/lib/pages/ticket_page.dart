import 'package:fioretti_app/widgets/scaffold.dart';
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
      body: Center(
        child: ticket == null
            ? const Text("Bezig met laden...")
            : Column(
                children: [
                  Text(ticket!.event.title),
                  Text(ticket!.event.description),
                  Text(ticket!.event.date),
                  ElevatedButton(
                      onPressed: () {
                        context.push("/tickets/${ticket!.id}/qr",
                            extra: ticket);
                      },
                      child: const Text("Toon QR code"))
                ],
              ),
      ),
    );
  }
}
