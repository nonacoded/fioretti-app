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

  void setTicket(String ticketId) async {
    Ticket? ticket = await fetchTicket(ticketId);
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

  void refreshTicket() {
    setTicket(scannedTicket!.id);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Scan QR'),
              style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue[900], // achtergrondkleur van de knop
              onPrimary: Colors.white, // tekstkleur van de knop
            ),
              onPressed: () async {
                final result = await BarcodeScanner.scan();
                if (result.type == ResultType.Barcode) {
                  setTicket(result.rawContent);
                }
              },
            ),
            if (scannedTicket != null && userThatBoughtTicket != null)
              Column(
                children: [
                  EventDisplay(event: scannedTicket!.event),
                  Text(
                    "Ticket gekocht op: ${dateTimeToString(scannedTicket!.createdAt)} ${userThatBoughtTicket!.firstName != null ? 'door ${userThatBoughtTicket!.firstName}' : ''} ${userThatBoughtTicket!.lastName != null ? userThatBoughtTicket!.lastName : ''}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  scannedTicket!.isUsed
                      ? const Text(
                          "Deze ticket is al gebruikt",
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        )
                      : const Text(
                          "Niet gebruikt",
                          style: TextStyle(fontSize: 25),
                        ),
                  scannedTicket != null
                      ? MarkAsUsedButton(
                          ticket: scannedTicket!,
                          refreshTicketCallback: refreshTicket,
                        )
                      : Placeholder()
                ],
              ),
            ElevatedButton(
                onPressed: () {
                  setTicket("659feca27e5a22c34c37c99e");
                },
                child: const Text("test"),
                style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue[900], // achtergrondkleur van de knop
              onPrimary: Colors.white, // tekstkleur van de knop
            ),)
          ],
        ),
      ),
    );
  }
}

class MarkAsUsedButton extends StatefulWidget {
  final Ticket ticket;
  final Function refreshTicketCallback;
  const MarkAsUsedButton(
      {super.key, required this.ticket, required this.refreshTicketCallback});

  @override
  State<MarkAsUsedButton> createState() => _MarkAsUsedButtonState();
}

class _MarkAsUsedButtonState extends State<MarkAsUsedButton> {
  bool isLoading = false;
  bool isMarkedAsUsed = false;

  @override
  void initState() {
    super.initState();

    isMarkedAsUsed = widget.ticket.isUsed;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              setState(() {
                isLoading = true;
              });
              markTicketAsUsed(widget.ticket.id, !widget.ticket.isUsed)
                  .then((success) {
                setState(() {
                  if (success) {
                    isMarkedAsUsed = !isMarkedAsUsed;
                    isLoading = false;
                    widget.refreshTicketCallback();
                  }
                });
              });
            },
      child: Text(
        isLoading
            ? "Laden..."
            : (isMarkedAsUsed
                ? "Markeer als ongebruikt"
                : "Markeer als gebruikt"),
      ),
      
    );
  }
}
