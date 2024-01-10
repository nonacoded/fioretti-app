import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fioretti_app/models/ticket.dart';

class QrScanningPage extends StatefulWidget {
  const QrScanningPage({super.key});

  @override
  State<QrScanningPage> createState() => _QrScanningPageState();
}

class _QrScanningPageState extends State<QrScanningPage> {
  Ticket? scannedTicket;

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
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ${result.type}");
                print(
                    "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ${result.rawContent}");
                if (result.type == ResultType.Barcode) {
                  fetchTicket(result.rawContent).then((ticket) {
                    setState(() {
                      scannedTicket = ticket;
                    });
                  });
                }
              },
            ),
            if (scannedTicket != null)
              Column(
                children: [
                  Text(scannedTicket!.event.title),
                  Text(scannedTicket!.event.date.toString()),
                  Text(scannedTicket!.event.location),
                  Text(scannedTicket!.event.description),
                  Text(scannedTicket!.event.price.toString()),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
