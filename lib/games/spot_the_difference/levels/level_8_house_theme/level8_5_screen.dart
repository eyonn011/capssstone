import 'dart:async';
import 'package:capstone_focus/games/spot_the_difference/levelSeleectstd.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_1_ball_theme/1_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_1_ball_theme/6_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_2_cars_theme/level2_6_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_3_cats_theme/level3_6_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_4_clothes_theme/level4_6_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_5_cups_theme/level5_6_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_6_dishes_theme/level6_6_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_7_dogs_theme/level7_6_screen.dart';
import 'package:capstone_focus/games/spot_the_difference/levels/level_8_house_theme/level8_6_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class level8_5_screen extends StatefulWidget {
  final int initialScore;

  level8_5_screen({
    required this.initialScore,
  });

  @override
  _level8_5_screenState createState() => _level8_5_screenState();
}

class _level8_5_screenState extends State<level8_5_screen> {
  int timeLeft = 55; // Initial time left in seconds
  int score = 0; // Declare a score variable in the state
  bool isGameOver = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Initialize the score with the passed initial value
    score = widget.initialScore;
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timeLeft == 0) {
          // Game over, stop the timer
          timer.cancel();
          setState(() {
            isGameOver = true;
          });
        } else {
          setState(() {
            timeLeft--;
          });
        }
      },
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Your Score: $score'),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: ((context) =>
                          GameScreen1()))); // Close the dialog and navigate back to GameScreen
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      timeLeft = 60;
      isGameOver = false;
    });
    startTimer();
  }

  bool isCorrectImage() {
    // Replace with your logic to determine if the correct image is tapped
    // For simplicity, we'll assume the first image is the correct one
    return true;
  }

  void correctImageTap(String tappedImage) {
    // Check which image was tapped
    if (tappedImage == "assets/spotthedif/level_8_house_theme/5 diff.png") {
      setState(() {
        score++;
      });
      CorrectImage();
    } else {
      WrongImage();
    }
  }

  void CorrectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Increment the user's progress in Firebase Firestore
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final CollectionReference userLevels =
            FirebaseFirestore.instance.collection('user_levels');
        final User? user = _auth.currentUser;
        if (user != null) {
          userLevels.doc(user.uid).set({
            'level_5': false, // Mark Level 1 as completed
          }, SetOptions(merge: true)); // Merge with existing data if any
        }

        return AlertDialog(
          title: Text('Correct Image'),
          content: Text('Congratulations! You tapped the correct image.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => level8_6_screen(
                      initialScore: score,
                    ),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void WrongImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wrong Image'),
          content: Text('You picked the wrong image, Try Again.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Score Display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Lives Display
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/spotthedif/score.png",
                            width: 60,
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            " $score",
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "LEVEL 5",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),
              // Timer Display
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Time Left: $timeLeft seconds",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              // Images
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (isCorrectImage()) {
                          correctImageTap(
                              "assets/spotthedif/level_8_house_theme/5 diff.png");
                        } else {
                          WrongImage();
                        }
                      },
                      child: Image.asset(
                        "assets/spotthedif/level_8_house_theme/5 diff.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isCorrectImage()) {
                          correctImageTap(
                              "assets/spotthedif/level_8_house_theme/5.png");
                        } else {
                          WrongImage();
                        }
                      },
                      child: Image.asset(
                        "assets/spotthedif/level_8_house_theme/5.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (isCorrectImage()) {
                          correctImageTap(
                              "assets/spotthedif/level_8_house_theme/5.png");
                        } else {
                          WrongImage();
                        }
                      },
                      child: Image.asset(
                        "assets/spotthedif/level_8_house_theme/5.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isCorrectImage()) {
                          correctImageTap(
                              "assets/spotthedif/level_8_house_theme/5.png");
                        } else {
                          WrongImage();
                        }
                      },
                      child: Image.asset(
                        "assets/spotthedif/level_8_house_theme/5.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (isCorrectImage()) {
                          correctImageTap(
                              "assets/spotthedif/level_8_house_theme/5.png");
                        } else {
                          WrongImage();
                        }
                      },
                      child: Image.asset(
                        "assets/spotthedif/level_8_house_theme/5.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isCorrectImage()) {
                          correctImageTap(
                              "assets/spotthedif/level_8_house_theme/5.png");
                        } else {
                          WrongImage();
                        }
                      },
                      child: Image.asset(
                        "assets/spotthedif/level_8_house_theme/5.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ],
                ),
              ),

              // Game Over Message
              if (isGameOver)
                ElevatedButton(
                  onPressed: () {
                    showGameOverDialog();
                  },
                  child: Text("View Score"),
                ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpotTheDiffLevelSelect(),
                        ));
                  },
                  child: Text('Level Menu'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
