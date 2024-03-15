import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fioretti_app/models/ticket.dart';
import 'package:fioretti_app/widgets/ticket_card.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  late Future<List<Ticket>> futureTickets;

  @override
  void initState() {
    super.initState();

    futureTickets = fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Tickets",
      body: Center(
        child: FutureBuilder<List<Ticket>>(
          future: futureTickets,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Ticket> tickets = snapshot.data!;
              return ListView.builder(
                itemCount: tickets.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return TicketWidget(ticket: tickets[index]);
                },
              );
            } else {
              return const Text("Bezig met laden...");
            }
          },
        ),
      ),
    );
  }
}
