import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString('id') ?? '';
  return user_id;
}

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenPageState();
  }
}

class _RegisterScreenPageState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
