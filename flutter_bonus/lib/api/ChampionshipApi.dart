import 'package:http/http.dart';

class API {
  static Future getChampionships() {
    var url = "http://192.168.1.106:8000/team/championships/";
    return get(url);
  }
  

}
