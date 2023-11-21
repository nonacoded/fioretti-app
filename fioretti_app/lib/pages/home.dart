import "package:fioretti_app/models/school_event.dart";
import "package:fioretti_app/widgets/event.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<SchoolEvent>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fioretti App"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FutureBuilder<List<SchoolEvent>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SchoolEvent> events = snapshot.data!;
              return ListView.builder(
                itemCount: events.length,
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
      ),
    );
  }
}
