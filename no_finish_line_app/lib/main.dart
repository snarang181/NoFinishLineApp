import 'package:flutter/material.dart';
import 'package:no_finish_line_app/pages/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/createUser.dart';
import '../utils/constants.dart';
import '../pages/loginSignup.dart';
import '../pages/forgotPassword.dart';
import 'pages/workoutFeed.dart';
import '../pages/newWorkout.dart';
import '../pages/viewWorkout.dart';
import 'package:firebase_core/firebase_core.dart';

var user_id;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  user_id = prefs.getString('user_id');
  runApp(const MyApp());
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: user_id == null ? const LoginSignup() : const WorkoutFeed(),
      routes: {
        "/loginScreen": (context) => const LoginScreen(),
        "/createUser": (BuildContext context) => const CreateUser(),
        "/loginSignup": (BuildContext context) => const LoginSignup(),
        "/forgotPassword": (BuildContext context) => const ForgotPassword(),
        "/workoutFeed": (BuildContext context) => const WorkoutFeed(),
        "/newWorkout": (BuildContext context) => const NewWorkout(),
        "/viewWorkout": (BuildContext context) => const ViewWorkout(),
      },
    );
  }
}
