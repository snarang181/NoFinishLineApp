import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double screen_height = 0.0;
  double screen_width = 0.0;
  @override
  Widget build(BuildContext context) {
    get_login_state();
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
                    // color: Colors.white,
                    )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                  width: 200,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "No Finish Line",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black.withOpacity(1),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Container(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Developed By",
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "SamTrek",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ]),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> get_login_state() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');
    if (user_id == null) {
      Timer(const Duration(seconds: 4), () {
        Navigator.popAndPushNamed(context, "/loginSignup");
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Navigator.popAndPushNamed(context, "/workoutFeed");
      });
    }
  }
}
