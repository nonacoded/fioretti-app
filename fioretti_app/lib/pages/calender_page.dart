import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";

class CalenderPage extends ConsumerStatefulWidget {
  const CalenderPage({super.key});

  @override
  ConsumerState<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends ConsumerState<CalenderPage> {
  @override
  void initState() {
    super.initState();

    User? user = ref.read(userProvider);

    if (user == null) {
      context.go("/");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(userProvider);

    if (user == null) {
      return const Text(
          "Geen gebruiker gevonden, dit is een bug. Probeer de app opnieuw te starten.");
    }

    return AppScaffold(
      title: "Kalender",
        body: ListView(
        children: List.generate(10, (index) {
          /*return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EvenementDetailsPage(
                details: EvenementDetails(
                  title: title,
                  description: description,
                ),
              ),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Maand en Dag labels
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      month,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(day),
                  ],
                ),
                SizedBox(
                    width:
                        10), // Spatie tussen Maand/Dag en de titel/beschrijving
                // Titel en beschrijving
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                          height: 5), // Spatie tussen titel en beschrijving
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));*/
        String dateTimeToString(DateTime dateTime) {
  return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
}
         // return Placeholder();
          // Hier maak je een EventItemWidget voor elk evenement
          /*return EventItemWidget(
            month: 'Maand',
            day: 'Dag',
            title: 'Evenement ${index + 1}',
            description: 'Beschrijving van evenement ${index + 1}',
          );*/
        }),
      ),
      );
  }
}