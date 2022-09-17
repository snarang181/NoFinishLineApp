import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import '../main.dart';
import 'workoutFeed.dart';

class ViewWorkout extends StatefulWidget {
  const ViewWorkout({Key? key}) : super(key: key);

  @override
  State<ViewWorkout> createState() => _ViewWorkoutState();
}

class _ViewWorkoutState extends State<ViewWorkout> {
  double screen_height = 0.0;
  double screen_width = 0.0;
  bool fieldsSet = false;
  final TextEditingController _workoutName = TextEditingController();
  final TextEditingController _workoutDescription = TextEditingController();
  final TextEditingController _workoutDuration = TextEditingController();
  final TextEditingController _workoutCalories = TextEditingController();
  Map arg = Map();

  @override
  Widget build(BuildContext context) {
    arg = ModalRoute.of(context)!.settings.arguments as Map;
    setControllers();
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return !fieldsSet
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: THEME_COLOR),
            ),
          )
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: THEME_COLOR,
                  title: const Text('Update Workout'),
                ),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          left: 10.0,
                          right: 10.0,
                          bottom: 10.0,
                        ),
                        child: TextField(
                          controller: _workoutName,
                          decoration: const InputDecoration(
                            labelText: 'Workout Name',
                            labelStyle: TextStyle(color: THEME_COLOR),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _workoutDuration,
                          decoration: const InputDecoration(
                            labelText: 'Workout Duration (in mins)',
                            labelStyle: TextStyle(color: THEME_COLOR),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _workoutCalories,
                          decoration: const InputDecoration(
                            labelText: 'Calories Burned',
                            labelStyle: TextStyle(color: THEME_COLOR),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _workoutDescription,
                          decoration: const InputDecoration(
                            labelText: 'Workout Notes (optional)',
                            labelStyle: TextStyle(color: THEME_COLOR),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: THEME_COLOR),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: THEME_COLOR,
                                onPrimary: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              child: const Text(
                                'Update Workout',
                                style: TextStyle(fontSize: 15.0),
                              ),
                              onPressed: () {
                                update_workout();
                              },
                            ),
                          ),
                        ],
                      )
                    ])),
          );
  }

  Future<void> update_workout() async {
    showLoadingConst(context);
    final http.Response response = await http
        .post(Uri.parse(API_BASE_URL + '/user/update_workout'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'auth_key': API_AUTH_KEY,
              'user_id': arg['userid'].toString(),
              'workout_id': arg['workout_id'].toString(),
              'workout_name': _workoutName.text.toString(),
              'workout_duration': _workoutDuration.text.toString(),
              'workout_calories_burnt': _workoutCalories.text.toString(),
              'workout_notes': _workoutDescription.text.toString(),
              'workout_date': arg['workout_date'].toString(),
            }))
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response('Server Timeout', 500);
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Workout Updated Successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, "/workoutFeed");
    } else {
      const snackBar = SnackBar(
        content: Text('Server Error, please try again'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void setControllers() {
    _workoutName.text = arg['workout_name'];
    _workoutDescription.text = arg['workout_notes'];
    _workoutDuration.text = arg['workout_duration'];
    _workoutCalories.text = arg['workout_calories_burnt'];
    fieldsSet = true;
    setState(() {});
  }
}
