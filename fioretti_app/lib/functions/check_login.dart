import "package:requests/requests.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:fioretti_app/models/user.dart";

Future<User?> checkLogin() async {
  try {
    var response =
        await Requests.post("${dotenv.get('API_URL')}/auth/verifySession");
    //await Future.delayed(const Duration(seconds: 5)); // wacht 5 seconden (voor testen)
    if (response.statusCode == 200) {
      return User.fromJson(response.json());
    } else {
      print(response.json()["message"]);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}
