import "package:flutter/material.dart";
import "package:fioretti_app/pages/home.dart";
import "package:go_router/go_router.dart";

void main() {
  runApp(const FiorettiApp());
}

class FiorettiApp extends StatelessWidget {
  const FiorettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: "/", builder: (context, state) => const HomePage()),
          GoRoute(
              path: "/test", builder: (context, state) => const Text("Test"))
        ],
      ),
    );
  }
}
