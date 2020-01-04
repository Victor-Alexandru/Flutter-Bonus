import 'dart:convert';

import 'package:flutter_bonus/api/ChampionshipApi.dart';
import 'package:flutter_bonus/model/championship.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  group('Counter', () {
    test('DELETE API TEST', () async {
      List<Championship> championships = new List<Championship>();
      Championship c = Championship('a', 'a');

      String jsonDict =
          '{"total_matches":"' + '12' + '" , "trophy": "' + 'a' + '"}';

      String _url = 'http://192.168.1.106:8000/team/championships/';

      Map<String, String> headers = {"Content-type": "application/json"};
      Response response = await post(_url, headers: headers, body: jsonDict);
      int statusCode = response.statusCode;
      final Map parsed = json.decode(response.body.toString());
      c.id = parsed['id'];

      if (statusCode == 201) {
        championships.add(c);
      }

      expect(championships.length, 1);

      String _deleteUrl = _url + c.id.toString() + "/";

      Response resp = await API.makeDeleteRequest(_deleteUrl);

      expect(resp.statusCode, 204);
    });
  });
}
