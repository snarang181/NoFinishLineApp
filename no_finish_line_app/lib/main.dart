import 'package:flutter/material.dart';
import 'package:no_finish_line_app/pages/loginScreen.dart';
import '../pages/createUser.dart';
import '../utils/constants.dart';
import '../pages/loginSignup.dart';
import '../pages/forgotPassword.dart';
import '../pages/workoutFeed.dart';
import '../pages/newWorkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginSignup(),
      routes: {
        "/loginScreen": (context) => const LoginScreen(),
        "/createUser": (BuildContext context) => const CreateUser(),
        "/loginSignup": (BuildContext context) => const LoginSignup(),
        "/forgotPassword": (BuildContext context) => const ForgotPassword(),
        "/workoutFeed": (BuildContext context) => const WorkoutFeed(),
        "/newWorkout": (BuildContext context) => const NewWorkout(),
      },
    );
  }
}
