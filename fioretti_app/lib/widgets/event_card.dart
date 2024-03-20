import "package:flutter/material.dart";
import "package:fioretti_app/models/school_event.dart";
import "package:go_router/go_router.dart";
import 'package:fioretti_app/functions/utils.dart';

class SchoolEventWidget extends StatelessWidget {
  final SchoolEvent event;

  const SchoolEventWidget({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("/event/${event.id}");
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                event.description,
                style: const TextStyle(fontSize: 16.0),
              ),
              Align(alignment: Alignment.bottomRight, child: Text(
                "${dateToString(event.date)}",
                style: const TextStyle(fontSize: 10.0),
              ),),
            // Text(
              //   "${event.price}",
              //   style: const TextStyle(fontSize: 10.0),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
