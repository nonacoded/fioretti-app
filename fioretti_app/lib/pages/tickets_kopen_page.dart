import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fioretti_app/models/ticket.dart';
import 'package:fioretti_app/widgets/ticket_card.dart';

class TicketsKopenPage extends StatefulWidget {
  const TicketsKopenPage({super.key});

  @override
  State<TicketsKopenPage> createState() => _TicketsKopenPageState();
}

class _TicketsKopenPageState extends State<TicketsKopenPage> {
  
  late Future<List<Ticket>> futureTickets;

  @override
  void initState() {
    super.initState();

    futureTickets = fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Tickets kopen",
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
