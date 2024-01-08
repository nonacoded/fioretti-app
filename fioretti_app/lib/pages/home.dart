import "package:fioretti_app/models/school_event.dart";
import "package:fioretti_app/widgets/event.dart";
import "package:fioretti_app/widgets/logout_button.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<SchoolEvent>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fioretti App"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            const LogoutButton(),
            Text("Welkom ${user.firstName}!"),
            const Spacer(flex: 10),
            FutureBuilder<List<SchoolEvent>>(
              future: futureEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SchoolEvent> events = snapshot.data!;
                  return ListView.builder(
                    itemCount: events.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return SchoolEventWidget(
                          events[index].title, events[index].description);
                    },
                  );
                } else {
                  return Text("${snapshot.error}");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
