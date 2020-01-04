import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'api/ChampionshipApi.dart';
import 'detail/detail.dart';
import 'model/championship.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';

class ListScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ListPage(title: 'Championships'),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  List<Championship> championships = new List<Championship>();

  final _formKey = GlobalKey<FormState>();
  String _input_total_matches;
  String _input_trophy;
  final String url = "http://192.168.1.106:8000/team/championships/";

  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _textEditingControllerTM =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getChampionships();
  }

  Widget ChampionshipCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(content: Text("Tap"));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChampionshipDetailPage(
                    championships[index], url, championships, index)));
      },
      child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Hero(
                      tag: championships[index],
                      child: Image.asset("assets/badge.png"),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      championships[index].trophy,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.navigate_next, color: Colors.black38),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var favorite = Icons.favorite;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _getChampionships();
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: championships.length,
            itemBuilder: (context, index) => ChampionshipCell(context, index),
          ),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    _textEditingController.clear();
    _textEditingControllerTM.clear();
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Trophy",
              hintText: "not blank",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerTM,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Total Matches",
              hintText: "not blank",
            ),
          )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              if (_textEditingController.text != "" &&
                  _textEditingControllerTM.text != "") {
                var c = new Championship(
                    _textEditingControllerTM.text, _textEditingController.text);
                String jsonDict = '{"total_matches":"' +
                    _textEditingControllerTM.text +
                    '" , "trophy": "' +
                    _textEditingController.text +
                    '"}';

                check().then((intenet) async {
                  if (intenet != null && intenet) {
                    _makePostRequest(jsonDict, c);
                  } else {
                    Toast.show("Added local", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    c.id = -250;
                    setState(() {
                      championships.add(c);
                    });
                  }
                });
              }
            },
            child: Text("Save")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _getChampionships() async {
    championships.forEach((elem) async {
      if (elem.id == -250) {
        Map<String, String> headers = {"Content-type": "application/json"};
        String jsonDict = '{"total_matches":"' +
            elem.total_matches +
            '" , "trophy": "' +
            elem.trophy +
            '"}';
        // make POST request
        await post(url, headers: headers, body: jsonDict);
      }
    });

    API.getChampionships(url).then((response) {
      setState(() {
        print(response.body);
        Iterable list = json.decode(response.body);
        championships =
            list.map((model) => Championship.fromJson(model)).toList();
      });
    });
  }

  _makePostRequest(jsonDict, c) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: jsonDict);
    int statusCode = response.statusCode;
    final Map parsed = json.decode(response.body.toString());
    c.id = parsed['id'];

    if (statusCode == 201) {
      setState(() => this.championships.add(c));
      _textEditingController.clear();
      _textEditingControllerTM.clear();
    }
  }
}
