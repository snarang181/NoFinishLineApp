import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'workoutStats.dart';
import 'package:pie_chart/pie_chart.dart';

class WorkoutStats extends StatefulWidget {
  const WorkoutStats({Key? key}) : super(key: key);

  @override
  State<WorkoutStats> createState() => _WorkoutStatsState();
}

var stats = {};
bool statsReceived = false;
Map<String, double> workout_map = {};

class _WorkoutStatsState extends State<WorkoutStats> {
  double screen_height = 0.0;
  double screen_width = 0.0;

  @override
  void initState() {
    get_workout_stats();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return !statsReceived
        ? const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              backgroundColor: THEME_COLOR,
            )),
          )
        : Scaffold(
            body: Container(
            height: screen_height,
            width: screen_width,
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              children: [
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 20.0),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return generic_card(stats['total_workouts'].toString(),
                            'workouts completed this week');
                      }
                      if (index == 1) {
                        return generic_card(
                            stats['dominating_workout_week'].toString(),
                            'Favorite workout this week');
                      }
                      if (index == 2) {
                        return generic_card(
                            stats['avg_week_calories'].toString(),
                            'Average calories burned this week');
                      }
                      if (index == 3) {
                        return generic_card(
                            stats['avg_week_minutes'].toString(),
                            'Average minutes spent this week');
                      }
                      return Container();
                    }),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: PieChart(
                      dataMap: workout_map,
                    ),
                  ),
                ),
              ],
            ),
          ));
  }

  Widget generic_card(String text1, String text2) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              text1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            text2,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> get_workout_stats() async {
    final LocalStorage storage = LocalStorage('user_data');
    await storage.ready;
    String user_id = storage.getItem('user_id');
    final http.Response response = await http
        .post(Uri.parse(API_BASE_URL + '/user/workout_stats'),
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
      stats = (jsonDecode(response.body)['message']) as Map;
      for (var i in (stats['last_month_exe_prop'] as Map).keys) {
        workout_map[i] = stats['last_month_exe_prop'][i].toDouble();
      }
      statsReceived = true;
      if (mounted) {
        setState(() {});
      }
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
}
