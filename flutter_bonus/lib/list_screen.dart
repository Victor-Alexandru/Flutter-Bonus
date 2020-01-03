import 'package:flutter/material.dart';
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

  _ListPageState() {
    championships.add(new Championship('12', 'Liga 1 Bergembier'));
    championships.add(new Championship('13', 'Liga 1 Betano'));
    championships.add(new Championship('15', 'Ligue 1'));
    championships.add(new Championship('20', 'Medicine Championsip'));
  }

  Widget ChampionshipCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(content: Text("Tap"));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChampionshipDetailPage(championships[index])));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: championships.length,
            itemBuilder: (context, index) => ChampionshipCell(context, index),
          ),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
