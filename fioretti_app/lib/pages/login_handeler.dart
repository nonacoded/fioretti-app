import "dart:convert";
import "package:fioretti_app/widgets/scaffold.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:fioretti_app/models/api_error.dart";
import "package:fioretti_app/models/user.dart";
import 'package:fioretti_app/providers.dart';
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:fioretti_app/functions/utils.dart";
import "package:go_router/go_router.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:requests/requests.dart";
import "package:http/http.dart" as http;

class LoginHandeler extends ConsumerStatefulWidget {
  const LoginHandeler({super.key, this.token, this.expiresString});

  final String? token;
  final String? expiresString;

  @override
  ConsumerState<LoginHandeler> createState() => _LoginHandelerState();
}

class _LoginHandelerState extends ConsumerState<LoginHandeler> {
  bool errorOccurred = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    login();
  }

  Future login() async {
    if (widget.token != null && widget.expiresString != null) {
      DateTime expires;
      try {
        int expiresInt = int.parse(widget.expiresString!);
        expires = DateTime.fromMillisecondsSinceEpoch(expiresInt);
      } catch (e) {
        setState(() {
          errorOccurred = true;
          errorMessage =
              "Er is iets fout gegaan bij het inloggen: kon de vervaldatum niet parsen ($e)";
        });
        showSnackBar(errorMessage);
        return;
      }

      if (expires.isBefore(DateTime.now())) {
        setState(() {
          errorOccurred = true;
          errorMessage =
              "Er is iets fout gegaan bij het inloggen: de login token is verlopen";
          showSnackBar(errorMessage);
        });
        return;
      }

      // login confirmation token is correct, now try to exchange it for a session token cookie
      http.Response res;
      String reqUrl = "${dotenv.env['API_URL']!}/auth/exchangeToken";
      try {
        res = await Requests.post(reqUrl,
            body: {"confirmationToken": widget.token!},
            bodyEncoding: RequestBodyEncoding.JSON);
      } catch (e) {
        setState(() {
          errorOccurred = true;
          errorMessage =
              "Er is iets fout gegaan bij het inloggen: kon geen verbinding maken met de server ($e) ($reqUrl)";
          showSnackBar(errorMessage);
        });
        rethrow;
      }

      var hostname = Requests.getHostname(dotenv.env['API_URL']!);

      CookieJar cookieJar = await Requests.getStoredCookies(hostname);

      // check if cookie exists
      if (cookieJar["session"] == null) {
        setState(() {
          errorOccurred = true;
          errorMessage =
              "Er is iets fout gegaan bij het inloggen: de server heeft geen sessie cookie gestuurd";
          showSnackBar(errorMessage);
        });
        return;
      }

      // store cookie
      const storage = FlutterSecureStorage();
      await storage.write(key: "session", value: cookieJar["session"]!.value);

      print(cookieJar["session"]!.value);

      if (res.statusCode == 200) {
        if (!context.mounted) return;
        // login successful, set user and redirect to home page
        User user = User.fromJson(res.json());
        ref.read(userProvider.notifier).state = user;

        // redirect to home page, but wait until the next frame to prevent a crash
        Future.delayed(Duration.zero, () => context.go("/calendar"));
      } else {
        print("Er is iets fout gegaan");
        ApiError error = ApiError.fromJson(jsonDecode(res.body));
        setState(() {
          errorOccurred = true;
          errorMessage =
              "Er is iets fout gegaan bij het inloggen: [${res.statusCode}] ${error.message}";
          showSnackBar(errorMessage);
        });
      }
    } else {
      setState(() {
        errorOccurred = true;
        errorMessage =
            "Er is iets fout gegaan bij het inloggen: token of vervaldatum is null";
        showSnackBar(errorMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: !errorOccurred
          ? const Center(
              child: Text("Bezig met inloggen..."),
            )

          // error occurred
          : Center(
              child: Column(
                children: [
                  Text(errorMessage),
                  ElevatedButton(
                    onPressed: () {
                      context.go("/");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.lightBlue[900], // achtergrondkleur van de knop
                      foregroundColor: Colors.white, // tekstkleur van de knop
                    ),
                    child: const Text("Opniew Proberen"),
                  ),
                ],
              ),
            ),
    );
  }
}
