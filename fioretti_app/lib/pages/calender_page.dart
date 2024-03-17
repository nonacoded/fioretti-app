import 'package:flutter/material.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";
import 'package:fioretti_app/functions/utils.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEvents();
  }

  Future<List<Event>> fetchEvents() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Event(date: DateTime.now(), title: 'Evenement 1', description: 'Beschrijving van Evenement 1'),
      Event(date: DateTime.now().add(Duration(days: 1)), title: 'Evenement 2', description: 'Beschrijving van Evenement 2'),
    ];
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Kalender",
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),));
          } else if (snapshot.hasError) {
            return Center(child: Text('Fout bij het ophalen van evenementen'));
          } else {
            List<Event> events = snapshot.data ?? [];
            events.sort((a, b) => a.date.compareTo(b.date));
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                Event event = events[index];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(formatDateTime(event.date),
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(event.title),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(event.description),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Event {
  final DateTime date;
  final String title;
  final String description;

  Event({required this.date, required this.title, required this.description});
}



