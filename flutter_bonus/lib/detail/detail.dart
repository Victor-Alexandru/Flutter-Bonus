import 'package:flutter/material.dart';
import 'package:flutter_bonus/model/championship.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'package:connectivity/connectivity.dart';

class ChampionshipDetailPage extends StatefulWidget {
  Championship _currentChampionship;
  String _url;
  List<Championship> _championships;
  var _index;

  ChampionshipDetailPage(
      Championship c, String url, List<Championship> championships, var index) {
    _currentChampionship = c;
    _url = url;
    _championships = championships;
    _index = index;
  }

  @override
  _ChampionshipDetailPageState createState() => _ChampionshipDetailPageState(
      _currentChampionship, _url, _championships, _index);
}

class _ChampionshipDetailPageState extends State<ChampionshipDetailPage> {
  Championship _currentChampionship;
  List<Championship> _championships;
  var _index;
  final _formKey = GlobalKey<FormState>();
  String _input_total_matches;
  String _input_trophy;
  String _url;
  String _putUrl;
  String _deleteUrl;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  _ChampionshipDetailPageState(Championship c, String _url,
      List<Championship> championships, var index) {
    this._currentChampionship = c;
    _url = _url;
    _putUrl = _url + c.id.toString() + "/";
    _deleteUrl = _url + c.id.toString() + "/";
    _championships = championships;
    _index = index;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentChampionship.trophy),
      ),
      body: Container(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Hero(
                transitionOnUserGestures: true,
                tag: _currentChampionship,
                child: Transform.scale(
                  scale: 2.0,
                  child: Image.asset(
                    "assets/badge.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          _currentChampionship.trophy,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          _currentChampionship.total_matches,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                    onSaved: (value) => _input_trophy = value, // <= NEW
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Trophy")),
                TextFormField(
                    onSaved: (value) => _input_total_matches = value, // <= NEW
                    decoration: InputDecoration(labelText: "Total matches")),
                RaisedButton(
                  onPressed: () {
                    final form = _formKey.currentState;

                    if (form != null) {
                      form.save();

                      if (form.validate()) {
                        if (_input_total_matches != "" && _input_trophy != "") {
                          String json = '{"total_matches":"' +
                              _input_total_matches +
                              '" , "trophy": "' +
                              _input_trophy +
                              '"}';
                          _makePutrequest(
                              json, _input_total_matches, _input_trophy);
                        }
                      }
                    }
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  color: Colors.green,
                ),
                RaisedButton(
                  onPressed: () => {
                    this._delete(_currentChampionship.id, _index),
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  _delete(c_id, _index) async {
    this.check().then((internet) async {
      if (internet != null && internet) {
        Response response = await delete(_deleteUrl);
        if (response.statusCode == 204) {
          setState(() {
            _championships.removeAt(_index);
            Navigator.pop(context);
          });
          print("delete a avut succcess");
        }
      } else {
        Toast.show("Delete off when no network", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }

  _makePutrequest(json, tm, trp) async {
    this.check().then((internet) async {
      if (internet != null && internet) {
        Map<String, String> headers = {"Content-type": "application/json"};
        Response response = await put(_putUrl, headers: headers, body: json);
        if (response.statusCode == 200) {
          setState(() {
            var c1 = new Championship(tm, trp);
            c1.id = _currentChampionship.id;
            setState(() {
              _championships[_index] = c1;
              _currentChampionship = c1;
            });
          });
          print("Put cu success");
          // Navigator.pop(context);
        }
      } else {
        Toast.show("Update off when no network", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
