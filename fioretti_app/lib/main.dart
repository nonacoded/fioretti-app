import 'package:fioretti_app/pages/start_page.dart';
import "package:fioretti_app/pages/login_handeler.dart";
import "package:flutter/material.dart";
import "package:fioretti_app/pages/home.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fioretti_app/providers.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const FiorettiApp());
}

class FiorettiApp extends StatelessWidget {
  const FiorettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) => const StartPage(),
            ),
            GoRoute(
              path: "/home",
              builder: (context, state) => const HomePage(),
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
          ],
        ),
      ),
    );
  }
}
