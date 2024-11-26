import 'package:flutter/material.dart';
import 'package:fioretti_app/widgets/scaffold.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Notificaties",
      body: Center(
        child: Text(
          "Hier verschijnen notificaties!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
