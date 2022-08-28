import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  double screen_height = 0.0;
  double screen_width = 0.0;
  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: THEME_COLOR,
        toolbarHeight: 0,
      ),
      body: Center(
        child: Text('Forgot Password Here'),
      ),
    );
  }
}
