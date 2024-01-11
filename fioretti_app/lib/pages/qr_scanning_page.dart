import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fioretti_app/functions/utils.dart';
import 'package:fioretti_app/widgets/event_display.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fioretti_app/models/ticket.dart';
import 'package:fioretti_app/models/user.dart';

class QrScanningPage extends StatefulWidget {
  const QrScanningPage({super.key});

  @override
  State<QrScanningPage> createState() => _QrScanningPageState();
}

class _QrScanningPageState extends State<QrScanningPage> {
  Ticket? scannedTicket;
  User? userThatBoughtTicket;

  void onBarcodeScanned(String barcodeContent) async {
    Ticket? ticket = await fetchTicket(barcodeContent);
    if (ticket == null) {
      return;
    }

    User? userThatBoughtTicket = await getUserByID(ticket.userId);
    if (userThatBoughtTicket == null) {
      return;
    }

    setState(() {
      scannedTicket = ticket;
      this.userThatBoughtTicket = userThatBoughtTicket;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Scan QR'),
              onPressed: () async {
                final result = await BarcodeScanner.scan();
                if (result.type == ResultType.Barcode) {
                  onBarcodeScanned(result.rawContent);
                }
              },
            ),
            if (scannedTicket != null && userThatBoughtTicket != null)
              Column(
                children: [
                  EventDisplay(event: scannedTicket!.event),
                  Text(
                    "Ticket gekocht op: ${dateTimeToString(scannedTicket!.createdAt)} door ${userThatBoughtTicket!.firstName} ${userThatBoughtTicket!.lastName}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
