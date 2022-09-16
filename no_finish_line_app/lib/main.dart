import 'package:flutter/material.dart';
import 'package:no_finish_line_app/pages/loginScreen.dart';
import '../pages/createUser.dart';
import '../utils/constants.dart';
import '../pages/loginSignup.dart';
import '../pages/forgotPassword.dart';
import 'pages/workoutFeed.dart';
import '../pages/newWorkout.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
