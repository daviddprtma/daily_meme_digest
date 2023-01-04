import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:daily_meme_digest/screen/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

String user_name = "";
String user_password = "";
String error_login = "";

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Meme Digest',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenPageState();
  }
}

class _LoginScreenPageState extends State<LoginScreen> {
  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419103/memes/login.php"),
        body: {"username": user_name, "password": user_password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_name", user_name);
        prefs.setString("password", user_password);

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => MyApp()));
        main();
      } else {
        setState(() {
          error_login = "Username atau password salah";
        });
      }
    } else {
      throw Exception("Failed to read API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 500,
                child: Image.asset(
                  "assets/images/memewelcomescreen.jpg",
                  width: 30,
                ),
              ),
              Text("Daily Meme Digest", style: TextStyle(fontSize: 18)),
              Expanded(
                  child: Container(
                width: 500,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username"),
                      TextField(
                          decoration:
                              InputDecoration(hintText: "Enter your username"),
                          onChanged: (v) {
                            user_name = v;
                          })
                    ],
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                width: 500,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password"),
                      TextField(
                          obscureText: true,
                          decoration:
                              InputDecoration(hintText: "Enter your password"),
                          onChanged: (v) {
                            user_password = v;
                          })
                    ],
                  ),
                ),
              )),
              if (error_login != "")
                Text(error_login, style: TextStyle(color: Colors.red)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => RegisterScreen()));
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white),
                  )),
              Divider(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    doLogin();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  )),
              Divider(
                height: 10,
              )
            ]));
  }
}
