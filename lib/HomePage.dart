import 'package:flutter/material.dart';
import 'package:snake_game/Arcade.dart';

import 'Game.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snakey snake'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              minWidth: 200.0,
              height: 70.0,
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: playGame,
                    child: Text('Classic', style: TextStyle(fontSize: 20),),
                  ),
                  RaisedButton(
                    onPressed: playArcadeGame,
                    child: Text('Arcade', style: TextStyle(fontSize: 20),),
                  ),
                  RaisedButton(
                    onPressed: About,
                    child: Text('About', style: TextStyle(fontSize: 20),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playGame(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Game()));
  }
  void playArcadeGame(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ArcadeGame()));
  }
  void About(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('About'),
            content: Text('A Flutter Application by \nDamanjyot'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Back'),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  }
              ),
            ],
          );
        });
  }
}