import 'package:flutter/material.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";
import 'package:fioretti_app/functions/utils.dart';
import 'dart:math';

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
      Event(date: DateTime.now().add(Duration(days: 31)), title: 'Evenement 3', description: 'Beschrijving van Evenement 3: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 62)), title: 'Evenement 4', description: 'Beschrijving van Evenement 4: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 93)), title: 'Evenement 5', description: 'Beschrijving van Evenement 5: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 124)), title: 'Evenement 6', description: 'Beschrijving van Evenement 6: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 155)), title: 'Evenement 7', description: 'Beschrijving van Evenement 7: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 186)), title: 'Evenement 8', description: 'Beschrijving van Evenement 8: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 217)), title: 'Evenement 9', description: 'Beschrijving van Evenement 9: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 248)), title: 'Evenement 10', description: 'Beschrijving van Evenement 10: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 279)), title: 'Evenement 6', description: 'Beschrijving van Evenement 6: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 310)), title: 'Evenement 7', description: 'Beschrijving van Evenement 7: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 341)), title: 'Evenement 8', description: 'Beschrijving van Evenement 8: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 372)), title: 'Evenement 9', description: 'Beschrijving van Evenement 9: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 403)), title: 'Evenement 10', description: 'Beschrijving van Evenement 10: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 434)), title: 'Evenement 11', description: 'Beschrijving van Evenement 11: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
      Event(date: DateTime.now().add(Duration(days: 465)), title: 'Evenement 11', description: 'Beschrijving van Evenement 11: Dit is een langere beschrijving van het evenement om te testen hoe het eruitziet wanneer de beschrijving meer tekst bevat.'),
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
                String month = Utils.getMonthInLetters(event.date.month).substring(0, 3).toUpperCase();
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
                        SizedBox(
                          width: 30, // Verkleinde breedte voor linkerdeel
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                month,
                              ),
                              SizedBox(height: 8), // Ruimte tussen maand en dag
                              Text(
                                day,
                              ),
                            ],
                          ),
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
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
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
