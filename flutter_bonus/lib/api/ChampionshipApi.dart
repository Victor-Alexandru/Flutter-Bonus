import 'package:http/http.dart';
import 'dart:convert';

class API {
  static Future getChampionships(url) {
    return get(url);
  }

  static void makePostRequest(jsonDict, c, url, championships) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: jsonDict);

    int statusCode = response.statusCode;


    final Map parsed = json.decode(response.body.toString());

    c.id = parsed['id'];

    if (statusCode == 201) {
      championships.add(c);
    }
  }

  static Future<Response> makeDeleteRequest(_deleteUrl) async {
    return await delete(_deleteUrl);
  }
}
