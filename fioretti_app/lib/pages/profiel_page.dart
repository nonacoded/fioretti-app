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
    final User? user = ref.watch(userProvider);
double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (user == null) {
      return const Text(
          "Geen gebruiker gevonden, dit is een bug. Probeer de app opnieuw te starten.");
    }

    return AppScaffold(
      title: "Profiel",
      body: Container(
            width: width * 0.9,
            height: height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // title
                const SizedBox(height: 20),
                Align(alignment: Alignment.center,
                child: Container(child: Text("Mijn gegevens",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ), textAlign: TextAlign.left,
                    ),)),
                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft,
                    child: ProfileTile(
            icon: Icons.account_circle, // Standaard profielfoto-icoon
            text: "${user.firstName} ${user.lastName}",
          ), ),
          
          
          ProfileTile(
            icon: Icons.email,
            text: "${user.email}",
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: const LogoutButton(),)
        ]
      ),
  ));}
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileTile({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white, // achtergrondkleur van de cirkelavatar
        child: Icon(
          icon,
          color: Colors.lightBlue[900], // kleur van het pictogram in de cirkelavatar
        ),
      ),
      title: Text(text),
    );
  }
}