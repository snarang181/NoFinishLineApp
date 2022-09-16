import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
// import 'workoutStats_defunct.dart';
import '../main.dart';

class WorkoutStats extends StatefulWidget {
  const WorkoutStats({Key? key}) : super(key: key);

  @override
  State<WorkoutStats> createState() => _WorkoutStatsState();
}

class _WorkoutStatsState extends State<WorkoutStats> with RouteAware {
  double screen_height = 0.0;
  double screen_width = 0.0;
  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Text('Workout Stats'),
      ),
    );
  }
}
