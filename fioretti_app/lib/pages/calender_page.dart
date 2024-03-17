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
                // Extraheer de maand en dag uit de datum
                String month = Utils.getMonthInLetters(event.date.month);
                String day = event.date.day.toString();
                // Beperk de beschrijving tot één regel met puntjes indien nodig
                String description =
                    event.description.length > 30
                        ? event.description.substring(0, 30) + "..."
                        : event.description;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Linkerdeel: Maand en dag
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              month,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), // Ruimte tussen maand en dag
                            Text(
                              day,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16), // Ruimte tussen linker- en rechterdeel
                        // Rechterdeel: Titel van het evenement en beschrijving
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titel van het evenement
                            Text(
                              event.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Ruimte tussen titel en beschrijving
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

class Utils {
  static String getMonthInLetters(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maart';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Augustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: CalendarPage(),
  ));
}
