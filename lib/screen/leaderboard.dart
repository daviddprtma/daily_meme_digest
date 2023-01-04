import 'dart:convert';

import 'package:daily_meme_digest/class/geteaderboard.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class LeaderboardScreen extends StatefulWidget {
  @override
  State<LeaderboardScreen> createState() {
    return _LeaderboardScreenPageState();
  }
}

class _LeaderboardScreenPageState extends State<LeaderboardScreen> {
  List<GetLeaderboard> leaderboard = [];

  Future<String> fetchData() async {
    final response = await http.get(
        Uri.https("ubaya.fun", '/flutter/160419103/memes/leaderboard.php'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var leaders in json['data']) {
        GetLeaderboard ls = GetLeaderboard.fromJson(leaders);
        leaderboard.add(ls);
      }
      setState(() {});
    });
  }

  Widget listLeaderboard(list) {
    if (list != null) {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext ctx, int idx) {
          return Card(
            child: Container(
              width: 300,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(list[idx].link_meme.toString()),
                    ),
                  ),
                  Text(list[idx].nama_depan.toString() +
                      " " +
                      list[idx].nama_belakang.toString()),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                      Text(list[idx].likes.toString())
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: listLeaderboard(leaderboard),
          )
        ],
      )
      
    );
  }
}
