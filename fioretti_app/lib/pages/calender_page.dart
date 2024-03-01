import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";
import 'package:fioretti_app/functions/utils.dart';

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
          
       },
          );*/
          return const Placeholder();
  })
        )
   );
       /* child: Card(
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
                  Text("${dateTimeToString(event.date)} verdere info"),
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
               // Spatie tussen Maand/Dag en de titel/beschrijving
                // Titel en beschrijving
                
                    ],
                  ),
              ],
                ),
            ),
        ),
          );
        }
          ),
        ));
       
  //return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${minuteToString(dateTime.minute)}";

          //return Placeholder();
          // Hier maak je een EventItemWidget voor elk evenement
          /*return EventItemWidget(
            month: 'Maand',
            day: 'Dag',
            title: 'Evenement ${index + 1}',
            description: 'Beschrijving van evenement ${index + 1}',
          );*/
        }),
      ),
      );*/
  }
}