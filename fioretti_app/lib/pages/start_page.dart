import 'package:fioretti_app/providers.dart';
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:url_launcher/url_launcher.dart";
import "package:go_router/go_router.dart";
import "package:fioretti_app/functions/check_login.dart";

class StartPage extends ConsumerStatefulWidget {
  const StartPage({super.key});

  @override
  ConsumerState<StartPage> createState() => _StartPageState();
}

class _StartPageState extends ConsumerState<StartPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    checkLogin().then((user) {
      print(user);
      if (user != null) {
        ref.read(userProvider.notifier).state = user;
        context.go("/home");
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fioretti App"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: loading
            ? const Text("Laden...")
            // if loading is false, display button instead
            : ElevatedButton(
                onPressed: () async {
                  if (!await launchUrl(
                      Uri.parse(dotenv.env["LOGIN_WEBSITE_URL"]!))) {
                    throw Exception('Could not launch url');
                  }
                },
                child: const Text("Login"),
              ),
      ),
    );
  }
}
