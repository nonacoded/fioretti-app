import 'package:fioretti_app/models/ticket.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  final Ticket ticket;

  const QrCodePage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: ticket.event.title,
      body: Column(
         children:[ GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Image.asset(
                      'assets/logo.png',
                      width: 42, // Adjust the width to your desired size
                      height: 42, // Adjust the height to your desired size
                      semanticLabel:
                          'Home', // Added semantic label for accessibility
                    ),
                  ),
        QrImageView(
          data: ticket.id,
          version: QrVersions.auto,
          size: 50.0,
        ),
         ],  
    ),);
  }
}
