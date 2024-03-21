import 'package:fioretti_app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";
import 'package:fioretti_app/functions/utils.dart';
import 'package:fioretti_app/models/school_event.dart';
import 'dart:math';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late Future<List<SchoolEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = getEvents();
  }

  Future<List<SchoolEvent>> getEvents() async {
    List<SchoolEvent> events = await fetchEvents();

    return events;
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Kalender",
      body: FutureBuilder<List<SchoolEvent>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ));
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Fout bij het ophalen van evenementen'));
          } else {
            List<SchoolEvent> events = snapshot.data ?? [];
            events.sort((a, b) => a.date.compareTo(b.date));
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                SchoolEvent event = events[index];

                return SchoolEventCard(event: event);
              },
            );
          }
        },
      ),
    );
  }
}
