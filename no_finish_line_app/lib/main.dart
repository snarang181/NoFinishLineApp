import 'package:flutter/material.dart';
import 'package:no_finish_line_app/pages/loginScreen.dart';
import '../pages/createUser.dart';
import '../utils/constants.dart';
import '../pages/loginSignup.dart';

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
        "/loginScreen": (context) => LoginScreen(),
        "/createUser": (BuildContext context) => const CreateUser(),
        "/loginSignup": (BuildContext context) => const LoginSignup(),
      },
    );
  }
}
