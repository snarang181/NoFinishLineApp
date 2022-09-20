import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_finish_line_app/pages/newWorkout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import '../main.dart';
import 'package:pie_chart/pie_chart.dart';

class WorkoutFeed extends StatefulWidget {
  const WorkoutFeed({Key? key}) : super(key: key);

  @override
  State<WorkoutFeed> createState() => _WorkoutFeedState();
}

class _WorkoutFeedState extends State<WorkoutFeed>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<WorkoutFeed> {
  double screen_height = 0.0;
  double screen_width = 0.0;
  List workoutList = [];
  TextEditingController _workoutSearch = TextEditingController();
  TextEditingController _workoutLevel = TextEditingController();
  TextEditingController _workoutGroups = TextEditingController();
  TextEditingController _workoutType = TextEditingController();
  TextEditingController _workoutInstructions = TextEditingController();

  bool workoutAPIRecvd = false;

  bool firstTemp = true;
  Map arg = Map();
  late final _tabController = TabController(length: 3, vsync: this);

  var stats = {};
  bool statsReceived = false;
  bool statsEmpty = false;
  bool pastWorkoutsReceived = false;
  Map<String, double> workout_map = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    if (firstTemp) {
      Future.delayed(Duration.zero, () {
        showLoadingConst(context);
        get_workout_past_data();
        firstTemp = false;
      });
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: THEME_COLOR,
            toolbarHeight: 0,
            bottom: TabBar(
              isScrollable: true,
              onTap: (value) {
                empty_controllers();
                _tabController.index = value;
                if (value == 0) {
                  showLoadingConst(context);
                  get_workout_past_data();
                } else if (value == 1) {
                  showLoadingConst(context);
                  get_workout_stats();
                }
              },
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'Workout History',
                ),
                Tab(
                  text: 'Workout Stats',
                ),
                Tab(
                  text: 'Workout Database',
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "logout",
                  backgroundColor: THEME_COLOR,
                  onPressed: () {
                    setState(() {});
                    logout();
                    Navigator.popAndPushNamed(context, "/loginSignup");
                  },
                  child: const Icon(Icons.logout_rounded),
                ),
                FloatingActionButton(
                  heroTag: "addWorkout",
                  backgroundColor: THEME_COLOR,
                  onPressed: () {
                    setState(() {});
                    Navigator.pushNamed(context, "/newWorkout");
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              !pastWorkoutsReceived
                  ? Container()
                  : workoutList.isEmpty
                      ? Column(
                          children: [
                            Image.asset('assets/images/splash.png'),
                            const Center(
                              child: Text(
                                  'No workouts logged, let\'s get started!'),
                            ),
                          ],
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
                                      Navigator.pushNamed(
                                          context, "/viewWorkout",
                                          arguments: workoutList[index]);
                                    },
                                    onLongPress: () {
                                      _showCupertinoDialog(
                                          workoutList[index]['workout_id'],
                                          index);
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
              !statsReceived
                  ? Container()
                  : workoutList.isEmpty
                      ? Column(
                          children: [
                            Image.asset('assets/images/stats.png'),
                            const Center(
                              child: Text(
                                  'No workouts logged, let\'s get started!'),
                            ),
                          ],
                        )
                      : statsPage(),
              database_search(),
            ],
          )),
    );
  }

  Widget database_search() {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   backgroundColor: THEME_COLOR,
          //   title: const Text('Workout Database'),
          // ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 400,
                    child: Autocomplete<Object>(
                      initialValue: TextEditingValue(
                          text: _workoutSearch.text.toString()),
                      onSelected: (value) {
                        setState(() {
                          _workoutSearch.text = value.toString();
                        });
                        showLoadingConst(context);
                        get_single_workout_data();
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return workouts
                            .where((suggestion) =>
                                (suggestion.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase())) ||
                                (suggestion.toLowerCase().startsWith(
                                    textEditingValue.text.toLowerCase())))
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
                          decoration: InputDecoration(
                            labelText: !workoutAPIRecvd
                                ? 'Start typing to search for a workout'
                                : 'Workout Name',
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
                    controller: _workoutLevel,
                    decoration: const InputDecoration(
                      labelText: 'Workout Level',
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
                    controller: _workoutGroups,
                    decoration: const InputDecoration(
                      labelText: 'Muscle Groups Targeted',
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
                    controller: _workoutType,
                    decoration: const InputDecoration(
                      labelText: 'Workout Category',
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
                    maxLines: null,
                    controller: _workoutInstructions,
                    decoration: const InputDecoration(
                      labelText: 'How do you do it?',
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
              ],
            ),
          ),
        ));
  }

  void empty_controllers() {
    _workoutSearch.clear();
    _workoutLevel.clear();
    _workoutGroups.clear();
    _workoutType.clear();
    _workoutInstructions.clear();
    workoutAPIRecvd = false;
    setState(() {});
  }

  void get_single_workout_data() async {
    final LocalStorage storage = LocalStorage('user_data');
    await storage.ready;
    String user_id = storage.getItem('user_id');
    final http.Response response = await http
        .post(Uri.parse(API_BASE_URL + '/user/workout_details'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'auth_key': API_AUTH_KEY,
              'workout_name': _workoutSearch.text.toString(),
            }))
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response('Server Timeout', 500);
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['message'];
      _workoutLevel.text = data['level'];
      _workoutGroups.text = data['Muscle Groups'];
      _workoutType.text = data['category'];
      _workoutInstructions.text = data['instructions'];
      workoutAPIRecvd = true;
      setState(() {});
    } else {
      const snackBar = SnackBar(
        content: Text('Could not fetch workout data, please try again later'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
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
      pastWorkoutsReceived = true;
      setState(() {});
    } else {
      const snackBar = SnackBar(
        content: Text('Could not fetch past workouts, please try again'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }

  void _showCupertinoDialog(String workout_id, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Delete Workout'),
            content:
                const Text('Are you sure you want to delete this workout?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showLoadingConst(context);
                  delete_workout(workout_id, index);
                },
                child: const Text('Delete'),
              )
            ],
          );
        });
  }

  void delete_workout(String workout_id, int index) async {
    final LocalStorage storage = LocalStorage('user_data');
    await storage.ready;
    String user_id = storage.getItem('user_id');
    final http.Response response = await http
        .post(Uri.parse(API_BASE_URL + '/user/delete_workout'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'auth_key': API_AUTH_KEY,
              'user_id': user_id,
              'workout_id': workout_id,
            }))
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response('Server Timeout', 500);
    });
    if (response.statusCode == 200) {
      workoutList.removeAt(index);
      setState(() {});
      const snackBar = SnackBar(
        content: Text('Workout deleted successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(
        content: Text('Could not delete workout, please try again'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }

  Widget statsPage() {
    return statsEmpty
        ? Scaffold(
            body: Center(
              child: Text('No workouts logged, let\'s get started!'),
            ),
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
                      dataMap: workout_map.isEmpty ? {} : workout_map,
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

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
  }

  Future<void> get_workout_stats() async {
    final LocalStorage storage = LocalStorage('user_data');
    workout_map = {};
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
    if (response.statusCode == 201) {
      statsEmpty = true;
      statsReceived = true;
      setState(() {});
    } else if (response.statusCode == 200) {
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
    }
    Navigator.pop(context);
  }
}
