import 'package:daily_meme_digest/screen/login.dart';
import 'package:daily_meme_digest/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString('id') ?? '';
  return user_id;
}

class MyWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Daily Meme Diget",
        theme: ThemeData(primarySwatch: Colors.grey),
        home: WelcomeScreen());
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomeScreenPageState();
  }
}

class _WelcomeScreenPageState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/memewelcomescreen.jpg',
                width: 100,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 110),
                child:
                    Text('Daily Meme Digest', style: TextStyle(fontSize: 20)),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 200),
                child: Text(
                    'The place that you can laugh and share to us about the meme',
                    style: TextStyle(fontSize: 13)),
              ),
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text('Create Account'))),
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 400),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text('Sign In'))),
            )
          ],
        ));
  }
}
