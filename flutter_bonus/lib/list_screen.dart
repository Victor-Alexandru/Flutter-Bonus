import 'dart:convert';

import 'package:flutter/material.dart';
import 'api/ChampionshipApi.dart';
import 'detail/detail.dart';
import 'model/championship.dart';
import 'package:toast/toast.dart';

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
                builder: (context) =>
                    ChampionshipDetailPage(championships[index], url,championships,index)));
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
                Toast.show("You can submit", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
    API.getChampionships().then((response) {
      setState(() {
        print(response.body);
        Iterable list = json.decode(response.body);
        championships =
            list.map((model) => Championship.fromJson(model)).toList();
      });
    });
  }
}
