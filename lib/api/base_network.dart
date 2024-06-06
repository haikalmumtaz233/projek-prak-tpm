import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static final String baseUrl = "https://www.freetogame.com/api";

  static Future<List<dynamic>> get(String partUrl) async {
    final String fullUrl = "$baseUrl/$partUrl";
    debugPrint("BaseNetwork-fullUrl : $fullUrl");
    final response = await http.get(Uri.parse(fullUrl));
    debugPrint("BaseNetwork-response : ${response.body}");
    return _processResponse(response);
  }

  static Future<List<dynamic>> _processResponse(http.Response response) async {
    final body = response.body;
    if (body.isNotEmpty) {
      final jsonBody = json.decode(body) as List<dynamic>;
      return jsonBody;
    } else {
      debugPrint("processResponse error");
      return [];
    }
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK]-$value");
  }
}
