import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

String finalUsername = "";
String finalFirstName = "";
String finalLastName = "";
String finalDob = "";

class _CreateUserState extends State<CreateUser> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  double screen_height = 0.0;
  double screen_width = 0.0;
  int username_label = 2;
  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool onUsername = false;
  bool usernameValid = false;
  bool nameValid = false;
  bool lastNameValid = false;
  bool passValid = false;
  bool onPassword = false;
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  bool passCond1 = false;
  bool passCond2 = false;
  bool passCond3 = false;
  bool passCond4 = false;
  bool passCond5 = false;

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create User"),
          toolbarHeight: 0,
          backgroundColor: THEME_COLOR,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: THEME_COLOR,
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screen_height * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Welcome to NoFinishLine',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: "Lato"),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 8),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _firstNameController,
                        onTap: () {
                          onUsername = false;
                          onPassword = false;
                          setState(() {});
                        },
                        onFieldSubmitted: (text) {},
                        onChanged: (text) {
                          finalFirstName = text;
                          validate_name(text);
                          setState(() {});
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person_add_alt_rounded,
                            color: THEME_COLOR,
                          ),
                          labelText: "First Name",
                          hintText: "Type your first name",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _firstNameController.text.isEmpty
                                      ? THEME_COLOR
                                      : nameValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2)),
                          labelStyle: const TextStyle(color: THEME_COLOR),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _firstNameController.text.isEmpty
                                      ? THEME_COLOR
                                      : nameValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _lastNameController,
                        onTap: () {
                          onUsername = false;
                          onPassword = false;
                          setState(() {});
                        },
                        onFieldSubmitted: (text) {},
                        onChanged: (text) {
                          finalLastName = text;
                          validate_lname(text);
                          setState(() {});
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person_add, color: THEME_COLOR),
                          labelText: "Last Name",
                          hintText: "Type your last name",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _lastNameController.text.isEmpty
                                      ? THEME_COLOR
                                      : lastNameValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2)),
                          labelStyle: const TextStyle(
                            color: THEME_COLOR,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _lastNameController.text.isEmpty
                                      ? THEME_COLOR
                                      : lastNameValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          setState(() {
                            onUsername = true;
                            onPassword = false;
                          });
                        },
                        controller: _emailController,
                        onFieldSubmitted: (text) {},
                        onChanged: (text) {
                          finalUsername = text;
                          usernameValid = false;
                          validate_username(text);
                          // username_label = 2;
                          setState(() {});
                          usernameexists();
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.create_rounded,
                            color: THEME_COLOR,
                          ),
                          labelText: "Email",
                          hintText: "Enter your email",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _emailController.text.isEmpty
                                      ? THEME_COLOR
                                      : usernameValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2)),
                          labelStyle: const TextStyle(
                            color: THEME_COLOR,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: _emailController.text.isEmpty
                                      ? THEME_COLOR
                                      : usernameValid
                                          ? Colors.green
                                          : Colors.red,
                                  width: 2)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2)),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 30, top: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                          _emailController.text.isEmpty
                              ? "Your username should be unique"
                              : username_label == 0
                                  ? "Username is not available"
                                  : username_label == 1
                                      ? "Username is available"
                                      : "Checking...",
                          style: TextStyle(
                              color: _emailController.text.isEmpty
                                  ? Colors.red
                                  : username_label == 0
                                      ? Colors.red
                                      : username_label == 1
                                          ? Colors.green
                                          : Colors.black,
                              fontSize: 12)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: TextFormField(
                    onTap: () {
                      onPassword = true;
                      onUsername = false;
                      setState(() {});
                    },
                    obscureText: _obscured,
                    controller: _passwordController,
                    onChanged: (text) {
                      validPass1(text);
                      validPass2(text);
                      validPass3(text);
                      validPass4(text);
                      validPass5(text);
                      validPass(text);
                      setState(() {});
                    },
                    textInputAction: TextInputAction.next,
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
                        hintText: "Type your password",
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2)),
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
                onPassword
                    ? Padding(
                        padding: const EdgeInsets.only(top: 7, left: 0),
                        child: Container(
                          width: screen_width - 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              passCond1
                                  ? showPasswordRules(0, Colors.green)
                                  : showPasswordRules(0, Colors.red),
                              passCond2
                                  ? showPasswordRules(1, Colors.green)
                                  : showPasswordRules(1, Colors.red),
                              passCond3
                                  ? showPasswordRules(2, Colors.green)
                                  : showPasswordRules(2, Colors.red),
                              passCond4
                                  ? showPasswordRules(3, Colors.green)
                                  : showPasswordRules(3, Colors.red),
                              passCond5
                                  ? showPasswordRules(4, Colors.green)
                                  : showPasswordRules(4, Colors.red),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ))
                    : SizedBox(
                        height: 10,
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _ageController,
                    onTap: () {
                      onPassword = false;
                      onPassword = false;
                      setState(() {});
                    },
                    onFieldSubmitted: (text) {},
                    onChanged: (text) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.cake_rounded,
                        color: THEME_COLOR,
                      ),
                      labelText: "Age",
                      hintText: "Enter your age",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: _ageController.text.isEmpty
                                  ? THEME_COLOR
                                  : Colors.green,
                              width: 2)),
                      labelStyle: const TextStyle(color: THEME_COLOR),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: _ageController.text.isEmpty
                                  ? THEME_COLOR
                                  : Colors.green,
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _weightController,
                    onTap: () {
                      onPassword = false;
                      onUsername = false;
                      setState(() {});
                    },
                    onFieldSubmitted: (text) {},
                    onChanged: (text) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.monitor_weight_rounded,
                        color: THEME_COLOR,
                      ),
                      labelText: "Weight",
                      hintText: "Enter your weight (in lbs)",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: _weightController.text.isEmpty
                                  ? THEME_COLOR
                                  : Colors.green,
                              width: 2)),
                      labelStyle: const TextStyle(color: THEME_COLOR),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: _weightController.text.isEmpty
                                  ? THEME_COLOR
                                  : Colors.green,
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: TextButton(
                    onPressed: () {
                      save();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: THEME_COLOR,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text(
                              'Create Your Fitness Profile',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    style: TextButton.styleFrom(
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: THEME_COLOR),
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: THEME_COLOR),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> save() async {
    if (nameValid && usernameValid && passValid) {
      final LocalStorage storage = LocalStorage('user_data');
      await storage.ready;
      showLoadingConst(context);
      final http.Response response = await http.post(
        Uri.parse(API_BASE_URL + '/user/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'auth_key': API_AUTH_KEY,
          "first_name": _firstNameController.text.toString(),
          "last_name": _lastNameController.text.toString(),
          "age": _ageController.text.toString(),
          "weight": _weightController.text.toString(),
          'id': _emailController.text.toString().trim(),
          'password': _passwordController.text.toString(),
        }),
      );
      Navigator.pop(context);
      if (response.statusCode == 202) {
        const snackBar = SnackBar(
          content: Text('Profile created'),
          backgroundColor: THEME_COLOR,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // first = true;
        await storage.setItem('user_id', jsonDecode(response.body)['userID']);
        await storage.setItem(
            'auth_token', jsonDecode(response.body)['auth_token']);
        Navigator.pop(context);
      } else if (response.statusCode == 401) {
        const snackBar = SnackBar(
          content: Text('User Already Exists'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      } else {
        const snackBar = SnackBar(
          content: Text('Server error'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      const snackBar = SnackBar(
        content: Text('All fields are mandatory'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String? validPass(String userInput) {
    passValid = false;
    if (userInput.length < 8) {
      return "Password should be minimum 8 characters";
    }
    if (!userInput.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Atleast one special character";
    }
    if (!userInput.contains(new RegExp(r'[A-Z]'))) {
      return "Atleast one uppercase character";
    }
    if (!userInput.contains(new RegExp(r'[a-z]'))) {
      return "Atleast one lowercase character";
    }
    if (!userInput.contains(new RegExp(r'[0-9]'))) {
      return "Atleast one digit";
    }
    passValid = true;
    return null;
  }

  String? validPass1(String userInput) {
    passCond1 = false;
    if (userInput.length < 8) {
      return "Password should be minimum 8 characters";
    } else {
      passCond1 = true;
      return null;
    }
  }

  String? validPass2(String userInput) {
    passCond2 = false;
    if (!userInput.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Atleast one special character";
    } else {
      passCond2 = true;
      return null;
    }
  }

  String? validPass3(String userInput) {
    passCond3 = false;
    if (!userInput.contains(new RegExp(r'[A-Z]'))) {
      return "Atleast one uppercase character";
    } else {
      passCond3 = true;
      return null;
    }
  }

  String? validPass4(String userInput) {
    passCond4 = false;
    if (!userInput.contains(new RegExp(r'[a-z]'))) {
      return "Atleast one lowercase character";
    } else {
      passCond4 = true;
      return null;
    }
  }

  String? validPass5(String userInput) {
    passCond5 = false;
    if (!userInput.contains(new RegExp(r'[0-9]'))) {
      return "Atleast one digit";
    } else {
      passCond5 = true;
      return null;
    }
  }

  Text showPasswordRules(int index, Color c) {
    switch (index) {
      case 0:
        return Text("Password should be minimum 8 characters",
            style:
                TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w500));
      case 1:
        return Text("Atleast one special character",
            style:
                TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w500));
      case 2:
        return Text("Atleast one uppercase character",
            style:
                TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w500));

      case 3:
        return Text("Atleast one lowercase character",
            style:
                TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w500));
      case 4:
        return Text("Atleast one digit",
            style:
                TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w500));
      default:
        return Text("");
    }
  }

  bool validate_username(String username) {
    if (username.toString().contains('@') &&
        username.toString().contains('.com')) {
      usernameValid = true;
      return true;
    }
    usernameValid = false;
    return false;
  }

  bool validate_name(String name) {
    if (name.toString().length > 0) {
      nameValid = true;
      return true;
    }
    nameValid = false;
    return false;
  }

  bool validate_lname(String name) {
    if (name.toString().length > 0) {
      lastNameValid = true;
      return true;
    }
    lastNameValid = false;
    return false;
  }

  Future<void> usernameexists() async {
    if (_emailController.text.isNotEmpty) {
      final http.Response response = await http.post(
        Uri.parse(API_BASE_URL + '/user/exists'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'auth_key': API_AUTH_KEY,
          'email': _emailController.text.toString().trim()
        }),
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['message'] == 'User does not exist') {
        username_label = 1;
      } else {
        username_label = 0;
        usernameValid = false;
      }
      setState(() {});
    } else {
      username_label = 2;
      setState(() {});
    }
  }
}
