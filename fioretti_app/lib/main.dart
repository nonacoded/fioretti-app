import "package:fioretti_app/models/ticket.dart";
import "package:fioretti_app/pages/calender_page.dart";
import "package:fioretti_app/pages/profiel_page.dart";
import "package:fioretti_app/pages/qr_display.dart";
import 'package:fioretti_app/pages/start_page.dart';
import "package:fioretti_app/pages/login_handeler.dart";
import "package:fioretti_app/pages/event_page.dart";
import "package:fioretti_app/pages/ticket_page.dart";
import "package:fioretti_app/pages/tickets_page.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fioretti_app/pages/qr_scanning_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/services.dart'; 
import 'package:fioretti_app/pages/notifications_page.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: ".env");

  String stripeKey = dotenv.get("STRIPE_PUBLIC_KEY");
  Stripe.publishableKey = stripeKey;
  await Stripe.instance.applySettings();

  runApp(const FiorettiApp());
}

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class FiorettiApp extends StatelessWidget {
  const FiorettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.1,
                fontSizeDelta: 2.0,
              ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) => const StartPage(),
            ),
            GoRoute(
              path: "/test",
              builder: (context, state) => const Text("Test"),
            ),
            GoRoute(
              path: "/login",
              builder: (context, state) => LoginHandeler(
                  token: state.uri.queryParameters["token"],
                  expiresString: state.uri.queryParameters["expires"]),
            ),
            GoRoute(
              name: "event",
              path: "/event/:id",
              builder: (context, state) => EventPage(
                id: state.pathParameters["id"]!,
              ),
            ),
            GoRoute(
              name: "tickets",
              path: "/tickets",
              builder: (context, state) => const TicketsPage(),
            ),
            GoRoute(
              name: "ticket",
              path: "/tickets/:id",
              builder: (context, state) =>
                  TicketPage(id: state.pathParameters["id"]!),
            ),
            GoRoute(
              name: "qrcode",
              path: "/tickets/:id/qr",
              builder: (context, state) {
                Ticket ticket = state.extra as Ticket;
                return QrCodePage(ticket: ticket);
              },
            ),
            GoRoute(
              name: "qr-scanning",
              path: "/qr-scanning",
              builder: (context, state) => const QrScanningPage(),
            ),
            GoRoute(
              name: "profiel",
              path: "/profile",
              builder: (context, state) => const ProfielPage(),
            ),
            GoRoute(
              name: "kalender",
              path: "/calendar",
              builder: (context, state) => const CalendarPage(),
            ),
            GoRoute(
              name: "notifications",
              path: "/notifications",
              builder: (context, state) => const NotificationsPage(),
            ),

          ],
        ),
      ),
    );
  }
}
