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
        crossAxisAlignment: CrossAxisAlignment.center,
         children:[ GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new// Added semantic label for accessibility
                    ),
                  ),
        QrImageView(
          data: ticket.id,
          version: QrVersions.auto,
          size: 250.0,
        ),
         ],  
    ),);
  }
}
