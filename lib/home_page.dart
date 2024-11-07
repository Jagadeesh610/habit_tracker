import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/util/habit_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //habit summary
  List habitList = [
    ['Code', false, 0, 1],
    ['Testing', false, 2, 20],
    ['Debug', false, 4, 20],
    ['Implement', false, 6, 40],
  ];

  void habitStarted(int index) {
    //note what the start time is for background run when phone is locked
    var startTime = DateTime.now();

    //include the already time
    int elapsedTime = habitList[index][2];

    //habit start and arop
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });
    //habit start keep going
    if (habitList[index][1]) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (habitList[index][1] == false) {
            timer.cancel();
          }

          //calculate the time
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Settings for" + habitList[index][0]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Habit Tracker",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: habitList.length,
          itemBuilder: ((context, index) {
            return HabitTitle(
              habitName: habitList[index][0],
              onTap: () {
                habitStarted(index);
              },
              settingsTapped: () {
                settingsOpened(index);
              },
              habitStarted: habitList[index][1],
              timeSpent: habitList[index][2],
              timeGol: habitList[index][3],
            );
          })),
    );
  }
}
