import 'package:flutter/material.dart';
import 'package:flutter_bonus/model/championship.dart';

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
        ]),
      ),
    );
  }
}

// Hero(
//               transitionOnUserGestures: true,
//               tag: _currentChampionship,
//               child: Transform.scale(
//                 scale: 2.0,
//                 child: Image.asset("assets/badge.png"),
//               ),
//             ),
