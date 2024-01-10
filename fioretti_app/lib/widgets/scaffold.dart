import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const AppScaffold(
      {super.key, this.title = "Fioretti App", required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Evenementen",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_activity), label: "Tickets"),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: "Scan Ticket"),
        ],
        onTap: (int index) {
          if (index == 0) {
            context.go("/home");
          } else if (index == 1) {
            context.go("/tickets");
          } else if (index == 2) {
            context.go("/qr-scanning");
          }
        },
      ),
    );
  }
}
