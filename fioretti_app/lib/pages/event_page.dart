import 'package:fioretti_app/functions/utils.dart';
import 'package:fioretti_app/models/school_event.dart';
import 'package:fioretti_app/models/ticket.dart';
import 'package:fioretti_app/widgets/event_display.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:requests/requests.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class EventPage extends StatefulWidget {
  final String id;

  const EventPage({super.key, required this.id});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  SchoolEvent? event;
  bool finishedLoading = false;
  bool canClickBuyButton = false;
  bool boughtTicket = false;

  @override
  void initState() {
    super.initState();

    fetchEvent(widget.id).then((event) {
      setState(() {
        this.event = event;
        finishedLoading = true;
      });

      if (event != null) {
        fetchOwnTicketByEventId(event.id).then((ticket) {
          setState(() {
            canClickBuyButton = ticket == null;
            boughtTicket = ticket != null;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Ticket info",
      body: Center(
        child: event == null
            ? Text(!finishedLoading
                ? "Bezig met laden..."
                : "Evenement niet gevonden")
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EventDisplay(event: event!),
                  ElevatedButton(
                    onPressed: !canClickBuyButton
                        ? null
                        : () {
                            getTicket(event!);
                            setState(() {
                              canClickBuyButton = false;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor:
                          Colors.lightBlue[900], // achtergrondkleur van de knop
                      foregroundColor: Colors.white, // tekstkleur van de knop
                    ),
                    child: Text(event!.price < 0.1
                        ? !boughtTicket
                            ? "Neem gratis ticket"
                            : "Ticket gekregen"
                        : !boughtTicket
                            ? "Koop ticket"
                            : "Ticket gekocht"),
                  )
                ],
              ),
      ),
    );
  }

  void getTicket(SchoolEvent event) async {
    if (event.price < 0.1) {
      claimFreeTicket(event);
      return;
    }

    buyTicket(event);
  }

  void buyTicket(SchoolEvent event) async {
    try {
      final response = await Requests.post(
          "${dotenv.env['API_URL']!}/events/${event.id}/buy");

      if (response.statusCode != 200) {
        print(
            "Ticket kopen mislukt! [${response.statusCode}] ${response.body}");
        showSnackBar(
            "Ticket kopen mislukt! [${response.statusCode}] ${response.body}");
      }

      Map<String, dynamic> paymentIntentJson = response.json();

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: "Fioretti College Lisse",
          paymentIntentClientSecret: paymentIntentJson["client_secret"],
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      showSnackBar(
          "Het betalen is gelukt! Kijk bij 'Mijn tickets' voor je ticket.");
    } catch (e) {
      var err = e as StripeException;
      if (err.error.code == FailureCode.Canceled) {
        showSnackBar("Het betalen is geannuleerd.");
      } else {
        showSnackBar("Het betalen is mislukt! Probeer het later opnieuw. $e");
      }
      setState(() {
        canClickBuyButton = true;
      });
    }
  }

  void claimFreeTicket(SchoolEvent event) async {
    final response = await Requests.post(
        "${dotenv.env['API_URL']!}/events/${event.id}/tickets");
    if (response.statusCode == 200) {
      print("Ticket gekocht!");
      showSnackBar("Je hebt je ticket ontvangen, kijk bij 'Mijn tickets'.");
    } else {
      print("Ticket kopen mislukt! [${response.statusCode}] ${response.body}");
    }
  }
}
