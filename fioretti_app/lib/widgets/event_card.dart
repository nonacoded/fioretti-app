import "package:flutter/material.dart";
import "package:fioretti_app/models/school_event.dart";
import "package:go_router/go_router.dart";
import 'package:fioretti_app/functions/utils.dart';

class SchoolEventCard extends StatelessWidget {
  final SchoolEvent event;

  const SchoolEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Extraheer de maand en dag uit de datum
    String month =
        getMonthInLetters(event.date.month).substring(0, 3).toUpperCase();
    String day = event.date.day.toString();
    // Beperk de beschrijving tot één regel met puntjes indien nodig
    String description = event.description.length > 40
        ? "${event.description.substring(0, 40)}..."
        : event.description;
    return GestureDetector(
      onTap: () {
        context.push("/event/${event.id}");
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linkerdeel: Maand en dag
              SizedBox(
                width: 35, // Verkleinde breedte voor linkerdeel
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      month,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8), // Ruimte tussen maand en dag
                    Text(
                      day,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16), // Ruimte tussen linker- en rechterdeel
              // Rechterdeel: Titel van het evenement en beschrijving
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titel van het evenement
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 4), // Ruimte tussen titel en beschrijving
                  // Beschrijving van het evenement
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
