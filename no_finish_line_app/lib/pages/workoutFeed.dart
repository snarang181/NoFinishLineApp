import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

class WorkoutFeed extends StatefulWidget {
  const WorkoutFeed({Key? key}) : super(key: key);

  @override
  State<WorkoutFeed> createState() => _WorkoutFeedState();
}

List workoutList = [];

class _WorkoutFeedState extends State<WorkoutFeed> {
  double screen_height = 0.0;
  double screen_width = 0.0;

  @override
  void initState() {
    get_workout_past_data();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    final List<String> appBarItems = [
      'Workout History',
      'Food History',
    ];
    return DefaultTabController(
      length: appBarItems.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: THEME_COLOR,
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: appBarItems
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: [
            workoutList.length == 0
                ? Center(
                    child: Text('No Workouts'),
                  )
                : ListView.builder(
                    itemCount: workoutList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(workoutList[index]['workout_name']),
                          subtitle: Text(
                              workoutList[index]['workout_date'].split(" ")[0] +
                                  " " +
                                  workoutList[index]['workout_calories_burnt']
                                      .toString() +
                                  " Calories"),
                        ),
                      );
                    },
                  ),
            Center(
              child: Text('Food History'),
            ),
          ],
        ),
      ),
    );
  }

  void get_workout_past_data() async {
    final LocalStorage storage = LocalStorage('user_data');
    await storage.ready;
    String user_id = storage.getItem('user_id');
    final http.Response response = await http
        .post(Uri.parse(API_BASE_URL + '/user/past_workouts'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'auth_key': API_AUTH_KEY,
              'user_id': user_id,
            }))
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response('Server Timeout', 500);
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      workoutList = data['message'];
      setState(() {});
    } else {
      const snackBar = SnackBar(
        content: Text('Could not fetch past workouts, please try again'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
