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
      body: Center(
        child: QrImageView(
          data: ticket.id,
          version: QrVersions.auto,
          size: 100.0,
        ),
      ),
    );
  }
}
