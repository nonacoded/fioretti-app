import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/ticket.dart";

class TicketWidget extends StatelessWidget {
  final Ticket ticket;

  const TicketWidget({required this.ticket});

  @override
  Widget build(BuildContext context) {
    String description = ticket.event.description.length > 100
        ? "${ticket.event.description.substring(0, 100)}..."
        : ticket.event.description;

    return GestureDetector(
      onTap: () {
        context.push("/tickets/${ticket.id}");
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.event.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
