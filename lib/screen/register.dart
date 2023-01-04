import 'dart:convert';

import 'package:daily_meme_digest/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String user_name = "";
String user_password = "";
String error_register = "";

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenPageState();
  }
}

class _RegisterScreenPageState extends State<RegisterScreen> {
  void registerUser() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419103/memes/register.php"),
        body: {'username': user_name, 'password': user_password});

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registration success.")));
      } else {
        setState(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Failed registration :D ")));
        });
      }
    } else {
      throw Exception("Failed to read API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          child: Text("Daily Meme Digest", style: TextStyle(fontSize: 18)),
        ),
        Container(
          child: Text("Create Account", style: TextStyle(fontSize: 18)),
        ),
        Expanded(
            child: Container(
          width: 500,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Username"),
                TextField(
                    decoration: InputDecoration(hintText: "Enter username"),
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Password"),
                TextField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter password"),
                    onChanged: (v) {
                      user_password = v;
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Repeat Password"),
                TextField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Repeat password"),
                    onChanged: (v) {
                      user_password = v;
                    })
              ],
            ),
          ),
        )),
        if (error_register != "")
          Text(error_register, style: TextStyle(color: Colors.red)),
        ElevatedButton(
            onPressed: () {
              registerUser();
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
            },
            child: Text(
              "Have an account? Login here",
              style: TextStyle(color: Colors.white),
            )),
      ]),
    );
  }
}
