import 'dart:ui';

import 'package:daily_meme_digest/screen/home.dart';
import 'package:daily_meme_digest/screen/leaderboard.dart';
import 'package:daily_meme_digest/screen/my_creation.dart';
import 'package:daily_meme_digest/screen/setting.dart';
import 'package:daily_meme_digest/screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(MyWelcome());
    } else {
      active_user = result;
      runApp(const MyApp());
    }
  });
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('username');
  main();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Daily Meme Digest',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const MyHomePage(title: 'Daily Meme Digest'),
        routes: {
          'home': (context) => HomeScreen(),
          'leaderboard': (context) => LeaderboardScreen(),
          'mycreation': (context) => MyCreationScreen(),
          'setting': (context) => SettingScreen()
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currIdx = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    LeaderboardScreen(),
    MyCreationScreen(),
    SettingScreen()
  ];

  final List _titles = ['Home', 'My Creation', 'Leaderboard', 'Setting'];

  blurImage() {
    ClipRRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Image.network('https://i.pravatar.cc/100'),
      ),
    );
  }

  Widget myDrawer() {
    return Drawer(
      elevation: 14.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(active_user),
              accountEmail: Text(""),
              otherAccountsPictures: [
                GestureDetector(
                    onTap: () {
                      doLogout();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(Icons.logout, color: Colors.white),
                    ))
              ],
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/100'))),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.popAndPushNamed(context, 'home');
            },
          ),
          ListTile(
            title: Text("My Creation"),
            leading: Icon(Icons.emoji_people),
            onTap: () {
              Navigator.popAndPushNamed(context, 'mycreation');
            },
          ),
          ListTile(
            title: Text("Leaderboard"),
            leading: Icon(Icons.leaderboard),
            onTap: () {
              Navigator.popAndPushNamed(context, 'leaderboard');
            },
          ),
          ListTile(
            title: Text("Setting"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.popAndPushNamed(context, 'setting');
            },
          )
        ],
      ),
    );
  }

  Widget myBottom() {
    return BottomNavigationBar(
      currentIndex: _currIdx,
      fixedColor: Colors.indigo,
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "My Creation",
          icon: Icon(Icons.emoji_people),
        ),
        BottomNavigationBarItem(
          label: "Leaderboard",
          icon: Icon(Icons.leaderboard),
        ),
        BottomNavigationBarItem(
          label: "Setting",
          icon: Icon(Icons.settings),
        ),
      ],
      onTap: (int index) {
        setState(() {
          _currIdx = index;
        });
      },
      selectedIconTheme: IconThemeData(color: Colors.black),
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currIdx]),
      ),
      body: _screens[_currIdx],
      drawer: myDrawer(),
      bottomNavigationBar: myBottom(),
    );
  }
}
