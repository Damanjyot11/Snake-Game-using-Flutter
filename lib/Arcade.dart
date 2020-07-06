import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class ArcadeGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArcadeGameState();
  }
}

class _ArcadeGameState extends State<ArcadeGame> {
  static List<int> snakePosition = [190, 210, 230, 250, 270];
  static var random = Random();

  int squareRow = 20;
  int squareCol = 34;
  int food = random.nextInt(600);
  int incrementTime = 85;
  int score = -1;
  String direction = 'right';
  bool isVisible = true;

  void startGame() {
    snakePosition = [];
    snakePosition = [190, 210, 230, 250, 270];
    var duration = Duration(milliseconds: incrementTime);
    score = 0;
    isVisible= false;
    Timer.periodic(duration, (timer) {
      updateSnake();
      if(gameOver()){
        timer.cancel();
        gameOverMenu();
      }
    });
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last + 660);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'down':
          if (snakePosition.last >= 660) {
            snakePosition.add(snakePosition.last - 660);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last + 19);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last - 19);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }
      if (snakePosition.last == food) {
        score++;
        generateFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  void generateFood() {
    food = random.nextInt(600);
  }

  bool gameOver(){
    if(score != 0)
      for(int i = 0;i < snakePosition.length;i++){
        for(int j = 0;j < snakePosition.length;j++){
          if(i != j && snakePosition[i] == snakePosition[j]){
            return true;
          }
        }
      }
    return false;
    }

  void gameOverMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('GAME OVER'),
            content: Text('You\'re score: ${score}'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Play Again?'),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ArcadeGame()));
                    direction = 'right';
                  }
              ),
              FlatButton(
                child: Text('Exit'),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  direction = 'right';
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child :Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: new Text(
            "",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.amber,
              child: Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: Text(
                      'Score : ${score}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                // Swipe Commands
                onVerticalDragUpdate: (details) {
                  if(score == -1){
                    score = 0;
                    startGame();
                  }

                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },

                onHorizontalDragUpdate: (details) {
                  if(score == -1){
                    score = 0;
                    startGame();
                  }

                  if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  } else if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  }
                },

                child: AspectRatio(
                  aspectRatio: (squareRow)/(squareCol),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: squareRow*squareCol,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: squareRow,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      }
                      if (index == food) {
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: ClipRRect(
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: MaterialButton(
                color: Colors.amber,
                child: Text('Start'),
                onPressed: startGame,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
