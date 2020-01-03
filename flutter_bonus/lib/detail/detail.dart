import 'package:flutter/material.dart';
import 'package:flutter_bonus/model/championship.dart';
import 'package:toast/toast.dart';

class ChampionshipDetailPage extends StatefulWidget {
  Championship _currentChampionship;

  ChampionshipDetailPage(Championship c) {
    _currentChampionship = c;
  }

  @override
  _ChampionshipDetailPageState createState() =>
      _ChampionshipDetailPageState(_currentChampionship);
}

class _ChampionshipDetailPageState extends State<ChampionshipDetailPage> {
  Championship _currentChampionship;

  final _formKey = GlobalKey<FormState>();
  String _input_total_matches;
  String _input_trophy;

  _ChampionshipDetailPageState(Championship c) {
    this._currentChampionship = c;
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
                    Toast.show("IN HANDLE  UPDATE", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    if (form != null) {
                      form.save();

                      if (form.validate()) {
                        if (_input_total_matches != "" && _input_trophy != "") {
                          Toast.show(
                              _input_trophy +
                                  "      :     " +
                                  _input_total_matches,
                              context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
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
}
