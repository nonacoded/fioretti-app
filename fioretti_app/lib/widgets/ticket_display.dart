import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fioretti_app/models/ticket.dart';

class TicketDisplay extends StatelessWidget {
  final Ticket ticket;

  const TicketDisplay({super.key, required this.ticket});

  static const TextStyle displayStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
            alignment: Alignment.center,
            width: width * 0.8,
            height: height * 0.4,
            child: Column(
              children: [
                Text("${ticket.event.title}", style: displayStyle),
                Text("Datum: ${ticket.event.date.toIso8601String()}",
                    style: displayStyle),
                Text("${ticket.event.location}", style: displayStyle),
                Text("${ticket.event.description}", style: displayStyle),
                Text("${ticket.event.price}", style: displayStyle),
              ],
            ))
      ],
    );
  }
}
