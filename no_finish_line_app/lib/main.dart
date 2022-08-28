import 'package:flutter/material.dart';
import 'package:no_finish_line_app/pages/loginScreen.dart';
import '../pages/createUser.dart';

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
      home: const LoginScreen(),
      routes: {
        "/loginScreen": (context) => LoginScreen(),
        "/createUser": (BuildContext context) => const CreateUser(),
      },
    );
  }
}
