import 'dart:convert';

import 'package:daily_meme_digest/screen/addMeme.dart';
import 'package:daily_meme_digest/screen/commentMeme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_meme_digest/class/meme.dart';
import 'package:http/http.dart' as http;

List<Meme> memes = [];
String active_user = "";

class HomeScreen extends StatefulWidget {
  final String user_name;
  HomeScreen({Key? key, required this.user_name}) : super(key: key);

  @override
  State<HomeScreen> createState() {
    return _HomeScreenPageState();
  }
}

class _HomeScreenPageState extends State<HomeScreen> {
  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_name = prefs.getString("user_name") ?? '';
    return user_name;
  }

  Future<String> fetchData() async {
    checkUser().then((String result) {
      setState(() {
        active_user = result;
      });
    });
    final response = await http.post(
        Uri.parse('https://ubaya.fun/flutter/160419103/memes/postmeme.php'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      for (var listmemes in json['data']) {
        Meme m = Meme.fromJson(listmemes);
        memes.add(m);
      }
      setState(() {});
    });
  }

  void getLike(Meme getPostLike) async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419103/memes/getlike.php"),
        body: {
          'id': getPostLike.id.toString(),
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        setState(() {
          getPostLike.likes++;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Cannot like the photo ')));
      }
    }
    print(response.body);
  }

  void getdisLike(Meme getPostLike) async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419103/memes/getdislike.php"),
        body: {
          'id': getPostLike.id.toString(),
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        setState(() {
          getPostLike.likes--;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Cannot like the photo ')));
      }
    }
    print(response.body);
  }

  Widget listMeme(listMemePost) {
    if (listMemePost == null) {
      return const CircularProgressIndicator();
    } else {
      return ListView.builder(
        itemCount: listMemePost.length,
        itemBuilder: (BuildContext ctx, int idx) {
          return Card(
              child: SingleChildScrollView(
            child: Container(
              width: 475,
              height: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 300,
                    child: Stack(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage(listMemePost[idx].link_meme),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: 300,
                          height: 300,
                          alignment: Alignment.topCenter,
                          child: Text(
                            listMemePost[idx].teks_atas.toString(),
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: 300,
                          height: 300,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            listMemePost[idx].teks_bawah.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: 300,
                      height: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Padding(
                                padding: EdgeInsets.all(3),
                                child: IconButton(
                                    onPressed: () {
                                      getLike(memes[idx]);
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 25,
                                    ))),
                            Text(
                              memes[idx].likes.toString() + " likes",
                              style: TextStyle(backgroundColor: Colors.white),
                            )
                          ]),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CommentMeme(
                                              memeID: memes[idx].id,
                                              user_name: active_user,
                                            )));
                              },
                              icon: Icon(
                                Icons.comment_bank,
                                color: Colors.blue,
                              ))
                        ],
                      ))
                ],
              ),
            ),
          ));
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    memes.clear();
    checkUser().then((String result) {
      setState(() {
        active_user = result;
      });
    });

    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 100,
            child: listMeme(memes),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AddMeme(
                    user_name: widget.user_name.toString(),
                  )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
