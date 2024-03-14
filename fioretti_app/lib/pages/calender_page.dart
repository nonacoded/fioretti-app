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
    _eventsFuture = fetchEvents(); // Vervang fetchEvents() met de methode om je evenementen op te halen
  }

  Future<List<Event>> fetchEvents() async {
    // Plaats hier de code om je evenementgegevens op te halen
    // Voor dit voorbeeld gebruiken we fictieve evenementgegevens
    await Future.delayed(Duration(seconds: 2)); // Simuleer een vertraging van 2 seconden
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
            List<Event> events = snapshot.data ?? [];
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                Event event = events[index];
                return Column(
                  children: [
                    // Divider tussen evenementen
                    Divider(),
                    // Maand (titel)
                    ListTile(
                      title: Text(
                        '${event.date.month}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Evenementinformatie
                    ListTile(
                      title: Text(
                        '${event.date.day}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(event.title),
                    ),
                    // Beschrijving evenement
                    ListTile(
                      title: Text(event.description),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Definieer de Event-klasse
class Event {
  final DateTime date;
  final String title;
  final String description;

  Event({required this.date, required this.title, required this.description});
}
