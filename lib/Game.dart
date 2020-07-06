import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  static List<int> snakePosition = [190, 210, 230, 250, 270];
  static List<int> walls1 = [284,304,324,344,364,295,315,335,355,375];
  static List<int> walls2 = [62,63,64,65,82,102,122,74,75,76,77,97,117,137,602,603,604,605,582,562,542,614,615,616,617,597,577,557];
  static List<int> walls3 = [167,168,169,170,171,172,507,508,509,510,511,512];
  static var random = Random();

  int squareRow = 20;
  int squareCol = 34;
  int food = random.nextInt(600);
  int incrementTime = 85;
  int score = -1;
  String direction = 'right';
  bool isVisible = true;

  void startGame() {
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
    for(int i=0;i<walls1.length;i++){
      if(food == walls1[i])
        food = random.nextInt(600);
    }
    for(int i=0;i<walls2.length;i++){
      if(food == walls2[i])
        food = random.nextInt(600);
    }
    for(int i=0;i<walls3.length;i++){
      if(food == walls3[i])
        food = random.nextInt(600);
    }
    if(score == 4)
      food = 0;
    else if(score == 9)
      food = 19;
    else if(score == 14)
      food = 0;
  }

  bool gameOver(){
    if(score != 0){
      for(int i = 0;i < snakePosition.length;i++){
        for(int j = 0;j < snakePosition.length;j++){
          if(i != j && snakePosition[i] == snakePosition[j]){
            return true;
          }
        }
      }
      for(int i=0;i < walls1.length;i++){
        if(score >= 5){
          if(snakePosition.last == walls1[i]){
            return true;
          }

        }
      }
      for(int i=0;i < walls2.length;i++){
        if(score >= 10){
          if(snakePosition.last == walls2[i]){
            return true;
          }
        }
      }
      for(int i=0;i < walls3.length;i++){
        if(score >= 15){
          if(snakePosition.last == walls3[i]){
            return true;
          }
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Game()));
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
         return Navigator.pushReplacement(
             context, MaterialPageRoute(builder: (context) => HomePage()));
       },
        child: Scaffold(
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
                        if(score >= 5 && walls1.contains(index)){
                          return Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        if(score >= 10 && walls2.contains(index)){
                          return Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        if(score >= 15 && walls3.contains(index)){
                          return Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Container(
                                color: Colors.grey,
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
