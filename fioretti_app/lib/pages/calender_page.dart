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
      body: Column(
        children: [
          // title
          const Text("Kalender",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              )),
          Text("Welkom ${user.firstName}!"),
        ],
      ),
    );
  }
}