import 'package:fioretti_app/widgets/scaffold.dart';
import "package:fioretti_app/widgets/logout_button.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import "package:go_router/go_router.dart";
import "package:fioretti_app/models/user.dart";

class ProfielPage extends ConsumerStatefulWidget {
  const ProfielPage({super.key});

  @override
  ConsumerState<ProfielPage> createState() => _ProfielPageState();
}

class _ProfielPageState extends State<ProfielPage> {
 

class _ProfielPageState extends ConsumerState<ProfielPage> {
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
    return AppScaffold(
    final User? user = ref.watch(userProvider);

    if (user == null) {
      return const Text(
          "Geen gebruiker gevonden, dit is een bug. Probeer de app opnieuw te starten.");
    }

    return AppScaffold(
      title: "Profiel",
      body: Column(
        children: [
                // title
                Text("Profiel",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),

          Row(
            children: [
              Icon(Icons.person),
              Text("gegevens",
                  style:
                      TextStyle(fontSize: 13.0, fontStyle: FontStyle.italic)),
            ],
          ),
        ],
      ),
    );
  }
}
