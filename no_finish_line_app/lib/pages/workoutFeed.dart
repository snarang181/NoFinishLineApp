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
bool data_received = false;

class _WorkoutFeedState extends State<WorkoutFeed> {
  double screen_height = 0.0;
  double screen_width = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    get_workout_past_data();
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    final List<String> appBarItems = [
      'Workout History',
      'Workout Stats',
    ];

    return !data_received
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(backgroundColor: THEME_COLOR),
            ),
          )
        : DefaultTabController(
            length: appBarItems.length,
            child: Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: THEME_COLOR,
                      onPressed: () {
                        Navigator.pushNamed(context, "/newWorkout");
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
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
                  workoutList.isEmpty
                      ? const Center(
                          child:
                              Text('No workouts logged, let\'s get started!'),
                        )
                      : SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: workoutList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      String workout_id =
                                          workoutList[index]['workout_id'];
                                    },
                                    child: Card(
                                      elevation: 5.0,
                                      child: ListTile(
                                        title: Text(
                                          workoutList[index]['workout_name'],
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(workoutList[index]
                                                    ['workout_date']
                                                .split(" ")[0] +
                                            " " +
                                            "Calories: " +
                                            workoutList[index]
                                                    ['workout_calories_burnt']
                                                .toString() +
                                            " " +
                                            "Duration: " +
                                            workoutList[index]
                                                    ['workout_duration']
                                                .toString() +
                                            " minutes"),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                  Center(
                    child: Text('Workout Stats Here'),
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
      data_received = true;
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
