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
      title: "Scan QR",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor:
                      Colors.lightBlue[900], // achtergrondkleur van de knop
                  foregroundColor: Colors.white, // tekstkleur van de knop
                  padding: const EdgeInsets.only(left: 27.0, right: 27.0)),
              onPressed: () async {
                final result = await BarcodeScanner.scan();
                if (result.type == ResultType.Barcode) {
                  setTicket(result.rawContent);
                }
              },
              child: const Text('Scan QR'),
            ),
            if (scannedTicket != null && userThatBoughtTicket != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EventDisplay(event: scannedTicket!.event),
                  Text(
                    "Ticket gekocht op: ${dateTimeToString(scannedTicket!.createdAt)} ${userThatBoughtTicket!.firstName != null ? 'door ${userThatBoughtTicket!.firstName}' : ''} ${userThatBoughtTicket!.lastName ?? ''}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  scannedTicket!.isUsed
                      ? const Text(
                          "Deze ticket is al gebruikt",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        )
                      : const Text(
                          "Niet gebruikt",
                          style: TextStyle(fontSize: 18),
                        ),
                  scannedTicket != null
                      ? MarkAsUsedButton(
                          ticket: scannedTicket!,
                          refreshTicketCallback: refreshTicket,
                        )
                      : const SizedBox(height: 10)
                ],
              ),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[900], // achtergrondkleur van de knop
        foregroundColor: Colors.white, // tekstkleur van de knop
      ),
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
