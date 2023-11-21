import "package:flutter/material.dart";
import "package:fioretti_app/pages/home.dart";

void main() {
  runApp(const FiorettiApp());
}

class FiorettiApp extends StatelessWidget {
  const FiorettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
