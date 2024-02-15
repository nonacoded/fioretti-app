import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class ProfielPage extends StatefulWidget {
  const ProfielPage({super.key});

  @override
  State<ProfielPage> createState() => _ProfielPageState();
}

class _ProfielPageState extends State<ProfielPage> {
 

  @override
  Widget build(BuildContext context) {
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
                    const Icon(Icons.person),
                    Text("gegevens",
                        style: const TextStyle(
                            fontSize: 13.0, fontStyle: FontStyle.italic)),
                  ],
                ),
        ],
      ),
    ),
  }
}
