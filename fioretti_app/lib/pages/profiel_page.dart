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

    if (user == null) {
      return const Text(
          "Geen gebruiker gevonden, dit is een bug. Probeer de app opnieuw te starten.");
    }

    return AppScaffold(
      title: "Profiel",
      body: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Text('Mijn gegevens:', textAlign: TextAlign.left, style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
          ),
          ProfileTile(
            icon: Icons.account_circle, // Standaard profielfoto-icoon
            text: "${user.firstName} ${user.lastName}",
          ),
          ProfileTile(
            icon: Icons.email,
            text: "${user.email}",
          ),
          const LogoutButton(),
        ],
      ),
    );
  }
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
        child: Icon(icon),
      ),
      title: Text(text),
    );
  }
}