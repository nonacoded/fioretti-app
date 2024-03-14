import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";
import 'package:fioretti_app/functions/utils.dart';
import 'package:fioretti_app/models/school_event.dart';
import 'package:fioretti_app/widgets/event_display.dart';

class CalendarPage extends StatelessWidget {
  final List<SchoolEvent> events;

  const CalendarPage({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          SchoolEvent event = events[index];
          return Column(
            children: [
              // Maand (titel)
              ListTile(
                title: Text(
                  '${event.date.month}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Evenementinformatie
              EventDisplay(event: event),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
