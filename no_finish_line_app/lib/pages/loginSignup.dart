// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_finish_line_app/pages/loginScreen.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:transition/transition.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({Key? key}) : super(key: key);

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  double screen_height = 0.0;
  double screen_width = 0.0;
  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: THEME_COLOR,
            toolbarHeight: 0,
          ),
          body: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 60.0,
                    bottom: 30.0,
                  ),
                  child: Image.asset('assets/images/no_end.jpeg',
                      //
                      width: screen_width * 0.8),
                ),
                SizedBox(
                  width: screen_width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "No Finish Line",
                        style: TextStyle(
                            color: THEME_COLOR,
                            fontSize: 37,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "You Snooze, You Lose",
                        style: TextStyle(color: THEME_COLOR, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      Transition(
                          child: const LoginScreen(),
                          transitionEffect: TransitionEffect.RIGHT_TO_LEFT)),
                  style: TextButton.styleFrom(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: THEME_COLOR, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white),
                  child: SizedBox(
                    width: screen_width * 0.8,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          alignment: Alignment.center,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () =>
                      {Navigator.pushNamed(context, '/createUser')},
                  style: TextButton.styleFrom(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: THEME_COLOR, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: THEME_COLOR),
                  child: SizedBox(
                    width: screen_width * 0.8,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          alignment: Alignment.center,
                          child: const Text(
                            'Create new account',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ]))),
    );
  }
}
