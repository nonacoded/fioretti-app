import "package:requests/requests.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:fioretti_app/models/user.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

Future<User?> checkLogin() async {
  print("checkLogin");
  // aqquire stored session
  var secureStorage = const FlutterSecureStorage();
  var sessionToken = await secureStorage.read(key: "session");

  if (sessionToken == null) {
    print("no session token found");
    return null;
  }
  print(sessionToken);
  // set session cookie
  String hostName = Uri.parse(dotenv.env["API_URL"]!).host;

  var cookieJar = await Requests.getStoredCookies(hostName);
  cookieJar["session"] = Cookie("session", sessionToken);
  await Requests.setStoredCookies(hostName, cookieJar);
  print("cookie set");

  // send request
  print("${dotenv.get('API_URL')}/auth/verifySession");
  try {
    var response =
        await Requests.post("${dotenv.get('API_URL')}/auth/verifySession");
    //await Future.delayed(const Duration(seconds: 5)); // wacht 5 seconden (voor testen)
    print(response.body);

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
