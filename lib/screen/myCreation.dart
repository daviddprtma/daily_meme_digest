import 'dart:convert';
import 'dart:html';

import 'package:daily_meme_digest/class/meme.dart';
import 'package:daily_meme_digest/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyCreationScreen extends StatefulWidget {
  final String user_name;
  MyCreationScreen({Key? key, required this.user_name}) : super(key: key);

  @override
  State<MyCreationScreen> createState() {
    return _MyCreationScreenPageState();
  }
}

class _MyCreationScreenPageState extends State<MyCreationScreen> {
  List<Meme> myCreationMeme = [];

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419103/memes/mycreationmeme.php"),
        body: {'user_name': widget.user_name.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      for (var meme in json['data']) {
        Meme m = Meme.fromJson(meme);
        myCreationMeme.add(m);
      }
      setState(() {});
    });
  }

  Widget MyCreationMeme(myCreation) {
    if (myCreation != null) {
      return ListView.builder(
          itemCount: myCreation.length,
          itemBuilder: (BuildContext ctx, int idx) {
            return Card(
              child: Container(
                width: 500,
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 300,
                      child: Stack(
                        children: [
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(myCreation[idx].link_meme),
                                    fit: BoxFit.fill)),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            height: 300,
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: Text(
                              myCreation[idx].teks_atas.toString(),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            height: 300,
                            width: 300,
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              myCreation[idx].teks_bawah.toString(),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 25,
                                      ))),
                              Text(
                                myCreation[idx].likes.toString() + " likes",
                                style: TextStyle(backgroundColor: Colors.white),
                              )
                            ]),
                            Icon(
                              Icons.comment,
                              color: Colors.blue,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Creation'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: MyCreationMeme(myCreationMeme),
            )
          ],
        ));
  }
}
