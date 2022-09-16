import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screen_height = 0.0;
  double screen_width = 0.0;
  TextEditingController __emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool passValid = false;
  bool emailValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  final textFieldFocusNode2 = FocusNode();

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
                child: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [THEME_COLOR, Colors.black, Colors.brown, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 50),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_sharp),
                color: Colors.black,
                iconSize: 30,
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/images/no_end.jpeg',
          // "../assets/images/no_end.jpeg",
          height: screen_height * 0.25,
        ),
        Container(
            width: screen_width,
            decoration: const BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Log back in to continue your journey",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: THEME_COLOR),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: TextFormField(
                      controller: __emailController,
                      onFieldSubmitted: (text) {
                        validateBoth(text);
                      },
                      onChanged: (text) {
                        validateBoth(text);
                        setState(() {});
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: THEME_COLOR,
                        ),
                        labelText: "Email Address",
                        hintText: "Type your email address",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: __emailController.text.isEmpty
                                    ? THEME_COLOR
                                    : emailValid
                                        ? Colors.green
                                        : Colors.red,
                                width: 2)),
                        labelStyle: const TextStyle(color: THEME_COLOR),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                // color: THEME_COLOR,
                                color: __emailController.text.isEmpty
                                    ? THEME_COLOR
                                    : emailValid
                                        ? Colors.green
                                        : Colors.red,
                                width: 2)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2)),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextFormField(
                      obscureText: _obscured,
                      controller: _passwordController,
                      onChanged: (text) {
                        validPass(text);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password_rounded,
                            color: THEME_COLOR,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                _obscured
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: THEME_COLOR,
                              ),
                            ),
                          ),
                          labelText: "Password",
                          errorText: _passwordController.text.isNotEmpty
                              ? validPass(_passwordController.text.toString())
                              : null,
                          hintText: "Type your password",
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                          labelStyle: const TextStyle(color: THEME_COLOR),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _passwordController.text.isEmpty
                                      ? THEME_COLOR
                                      : passValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _passwordController.text.isEmpty
                                      ? THEME_COLOR
                                      : passValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2))),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(context, "/forgotPassword",
                                arguments: {});
                          }),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: THEME_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextButton(
                      onPressed: () {
                        validateBothFields();
                      },
                      style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: THEME_COLOR, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: THEME_COLOR),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 35,
                            alignment: Alignment.center,
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/createUser",
                          arguments: {});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Not part of the journey yet?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "Let's change that",
                          style: TextStyle(
                            color: THEME_COLOR,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                ]))
      ]),
    ))));
  }

  void validateBothFields() {
    bool temp_flag = false;
    if (__emailController.text.toString().isNotEmpty && emailValid) {
      temp_flag = true;
    } else {
      const snackBar = SnackBar(
        content: Text('Type your email'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (temp_flag) {
      if (_passwordController.text.isNotEmpty && passValid) {
        showLoadingConst(context);
        workout_data();
      } else {
        const snackBar = SnackBar(
          content: Text('The password field is mandatory'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  bool validateBoth(String text) {
    return validateEmail(text);
  }

  bool validateEmail(String userInput) {
    if (userInput.contains('@') && userInput.contains('.com')) {
      emailValid = true;
    } else {
      emailValid = false;
    }
    return emailValid;
  }

  String? validPass(String userInput) {
    passValid = false;
    if (userInput.length < 8) {
      return "Password should be minimum 8 characters";
    }
    passValid = true;
    return null;
  }

  Future<void> workout_data() async {
    final LocalStorage storage = LocalStorage('user_data');
    try {
      final http.Response response = await http
          .post(Uri.parse(API_BASE_URL + '/user/login'),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonEncode(<String, String>{
                'user_id': __emailController.text.toString().toLowerCase(),
                'auth_key': API_AUTH_KEY,
                'password': _passwordController.text.toString()
              }))
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          return http.Response('Server Timeout', 500);
        },
      );
      print(response.body);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        await storage.setItem('user_id', jsonDecode(response.body)['userID']);
        await storage.setItem(
            'auth_token', jsonDecode(response.body)['auth_token']);
        Navigator.popAndPushNamed(context, "/workoutFeed",
            arguments: {'userid': jsonDecode(response.body)['userID']});
      } else if (response.statusCode == 401) {
        const snackBar = SnackBar(
          content: Text('Incorrect Password'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response.statusCode == 403) {
        const snackBar = SnackBar(
          content: Text('No account associated with these credentials'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Something went wrong, error caught'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
