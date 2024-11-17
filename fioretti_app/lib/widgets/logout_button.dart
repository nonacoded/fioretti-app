import 'package:fioretti_app/models/api_error.dart';
import 'package:fioretti_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  Future logout(BuildContext context, WidgetRef ref) async {
    http.Response res =
        await Requests.post("${dotenv.env['API_URL']!}/auth/logout");

    if (res.statusCode != 200) {
      ApiError error = ApiError.fromJson(jsonDecode(res.body));
      throw Exception("Failed to logout: ${res.statusCode} ${error.message}}");
    }
    if (!context.mounted) return;

    ref.read(userProvider.notifier).state = null;
    context.go("/");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => logout(context, ref),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(5.0),
                              ),
              backgroundColor: Colors.lightBlue[900], // achtergrondkleur van de knop
              foregroundColor: Colors.white, // tekstkleur van de knop
      ),
      child: const Text("Uitloggen")
    );
  }
}
