import 'package:bottom_picker/bottom_picker.dart';
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
  final TextEditingController _workoutNewDate = TextEditingController();
  bool workoutDateValid = false;
  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map arg = Map();
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    arg = ModalRoute.of(context)!.settings.arguments as Map;
    if (firstTime) {
      setControllers();
      firstTime = false;
    }
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return !fieldsSet
        ? const Scaffold(
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
                body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            child: Image.asset('assets/images/splash.png'),
                            height: screen_height * 0.3,
                            width: screen_width * 0.8,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 400,
                            child: Autocomplete<Object>(
                              initialValue: TextEditingValue(
                                  text: _workoutName.text.toString()),
                              onSelected: (value) {
                                setState(() {
                                  _workoutName.text = value.toString();
                                });
                              },
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                return workouts
                                    .where((suggestion) =>
                                        (suggestion.toLowerCase().contains(
                                            textEditingValue.text
                                                .toLowerCase())) ||
                                        (suggestion.toLowerCase().startsWith(
                                            textEditingValue.text
                                                .toLowerCase())))
                                    .toList();
                              },
                              displayStringForOption: (option) =>
                                  option.toString(),
                              fieldViewBuilder: (
                                BuildContext context,
                                TextEditingController
                                    fieldTextEditingController,
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
                                      borderSide: BorderSide(
                                          width: 3, color: THEME_COLOR),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: THEME_COLOR),
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
                          child: TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            controller: _workoutNewDate,
                            decoration: InputDecoration(
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  _openDatePicker();
                                },
                                child: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: THEME_COLOR,
                                ),
                              ),
                              labelText: 'Workout Date',
                              hintText:
                                  "Tap the calendar icon to select a date",
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
                                  validate_and_post();
                                },
                              ),
                            ),
                          ],
                        )
                      ]),
                )),
          );
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
    } else if (_workoutNewDate.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a date'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    } else {
      update_workout();
    }
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
              'workout_date': _workoutNewDate.text.toString(),
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

  void _openDatePicker() {
    try {
      // if (_workoutNewDate.text.isNotEmpty) {
      //   date = new DateTime(
      //       int.parse(
      //           _workoutNewDate.text.toString().split(" ")[0].split("/")[2]),
      //       int.parse(
      //           _workoutNewDate.text.toString().split(" ")[0].split("/")[0]),
      //       int.parse(
      //           _workoutNewDate.text.toString().split(" ")[0].split("/")[1]));
      // }
    } catch (e) {}

    BottomPicker.date(
            title: 'Set your workout date',
            height: screen_height * 0.4,
            initialDateTime: date,
            dateOrder: DatePickerDateOrder.dmy,
            pickerTextStyle: TextStyle(
              color: THEME_COLOR,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            titleStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: THEME_COLOR,
            ),
            onChange: (index) {
              setState(() {});
            },
            onSubmit: (index) {
              String temp = index.toString().split(" ")[0].split('-')[1] +
                  "/" +
                  index.toString().split(" ")[0].split('-')[2] +
                  "/" +
                  index.toString().split(" ")[0].split('-')[0];
              _workoutNewDate.text = temp;
              workoutDateValid = true;
              date = new DateTime(
                  int.parse(index.toString().split(" ")[0].split("-")[0]),
                  int.parse(index.toString().split(" ")[0].split("-")[1]),
                  int.parse(index.toString().split(" ")[0].split("-")[2]));
              setState(() {});
            },
            buttonText: "Save",
            displayButtonIcon: false,
            // backgroundColor: Colors.black,
            closeIconColor: THEME_COLOR,
            buttonTextStyle: TextStyle(
              fontSize: 20,
              color: THEME_COLOR,
            ),
            buttonSingleColor: Colors.transparent)
        .show(context);
  }

  void setControllers() {
    _workoutName.text = arg['workout_name'];
    _workoutDescription.text = arg['workout_notes'];
    _workoutDuration.text = arg['workout_duration'];
    _workoutCalories.text = arg['workout_calories_burnt'];
    _workoutNewDate.text = arg['workout_date'];
    fieldsSet = true;
    setState(() {});
  }
}
