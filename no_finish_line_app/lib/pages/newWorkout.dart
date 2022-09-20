import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'workoutFeed.dart';

class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  State<NewWorkout> createState() => _NewWorkoutState();
}

List workoutList = [];
bool data_received = false;

class _NewWorkoutState extends State<NewWorkout> {
  double screen_height = 0.0;
  double screen_width = 0.0;
  final TextEditingController _workoutName = TextEditingController();
  final TextEditingController _workoutDescription = TextEditingController();
  final TextEditingController _workoutDuration = TextEditingController();
  final TextEditingController _workoutCalories = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: THEME_COLOR,
            title: const Text('New Workout'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 400,
                    child: Autocomplete<Object>(
                      onSelected: (value) {
                        setState(() {
                          _workoutName.text = value.toString();
                        });
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return workouts
                            .where((suggestion) => suggestion
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()))
                            .toList();
                      },
                      displayStringForOption: (option) => option.toString(),
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
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
                        );
                      },
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
                        borderSide: BorderSide(width: 3, color: THEME_COLOR),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: THEME_COLOR),
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
                        borderSide: BorderSide(width: 3, color: THEME_COLOR),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: THEME_COLOR),
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
                        borderSide: BorderSide(width: 3, color: THEME_COLOR),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: THEME_COLOR),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        child: const Text(
                          'Create Workout',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        onPressed: () {
                          validate_and_post();
                        },
                      ),
                    ),
                  ],
                )
              ])),
    );
  }

  Future<void> log_workout_data() async {
    showLoadingConst(context);
    data_received = false;
    final LocalStorage storage = LocalStorage('user_data');
    await storage.ready;
    String user_id = storage.getItem('user_id');
    final http.Response response = await http
        .post(Uri.parse(API_BASE_URL + '/user/workout_log'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'auth_key': API_AUTH_KEY,
              'user_id': user_id,
              'workout_name': _workoutName.text.toString(),
              'workout_duration': _workoutDuration.text.toString(),
              'workout_calories_burnt': _workoutCalories.text.toString(),
              'workout_notes': _workoutDescription.text.toString(),
            }))
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response('Server Timeout', 500);
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      var data = jsonDecode(response.body);
      const snackBar = SnackBar(
        content: Text('Workout Logged Successfully'),
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
      Navigator.pop(context);
    }
  }

  void validate_and_post() {
    if (_workoutName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a workout name'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    } else if (_workoutDuration.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a workout duration'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    } else if (_workoutCalories.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter calories burned'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    } else {
      log_workout_data();
    }
  }
}
