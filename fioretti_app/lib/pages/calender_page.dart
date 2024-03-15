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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Kalender",
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fout bij het ophalen van evenementen'));
          } else {
            return ListView(
              children: snapshot.data!.map((event) => EventWidget(event: event)).toList(),
            );
          }
        },
      ),
    );
  }
}

class EventWidget extends StatelessWidget {
  final Event event;

  const EventWidget({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          title: Text(
            '${event.date.month}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text(
            '${event.date.day}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(event.title),
        ),
        ListTile(
          title: Text(event.description),
        ),
      ],
    );
  }
}

class Event {
  final DateTime date;
  final String title;
  final String description;

  Event({required this.date, required this.title, required this.description});
}


