import 'dart:convert';

import 'package:daily_meme_digest/class/meme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentMeme extends StatefulWidget {
  int memeID;
  final String user_name;
  CommentMeme({super.key, required this.memeID, required this.user_name});

  @override
  State<StatefulWidget> createState() {
    return _CommentMemeState();
  }
}

class _CommentMemeState extends State<CommentMeme> {
  final _form_key = GlobalKey<FormState>();
  String comment_meme = "";
  Meme? postMeme;

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419103/commentmeme.php"),
        body: {'meme_id': widget.memeID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void addCommentMeme() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419103/addcomment.php"),
        body: {
          'comment': comment_meme,
          'meme_id': widget.memeID.toString(),
          'user_name': widget.user_name.toString()
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Comment have been posted')));
      } else {
        throw Exception('Failed to read API');
      }
    }
  }

  bacaDataComment() {
    fetchData().then((value) {
      setState(() {
        Map json = jsonDecode(value);
        postMeme = Meme.fromJson(json['data']);
      });
    });
  }

  Widget tampilDataComment(Meme? memeComment) {
    if (memeComment == null) {
      return const CircularProgressIndicator();
    } else {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                width: 400,
                height: 350,
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
                                          NetworkImage(memeComment.link_meme),
                                      fit: BoxFit.fill)),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: 300,
                              height: 300,
                              alignment: Alignment.topCenter,
                              child: Text(
                                memeComment.teks_atas,
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: 300,
                              height: 300,
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                memeComment.teks_bawah,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        )),
                    Container(
                      width: 300,
                      height: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(3),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )),
                              ),
                              Text(memeComment.likes.toString() + " likes")
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: memeComment.user?.length,
                      itemBuilder: (BuildContext ctx, int idx) {
                        return ListTile(
                          title: Text(
                            memeComment.user?[idx]['user_name'],
                          ),
                          subtitle:
                              Text(memeComment.user?[idx]['isi_komentar']),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    bacaDataComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meme Detail'),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Container(child: tampilDataComment(postMeme)),
                Form(
                    key: _form_key,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 100,
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Write Comments'),
                            onChanged: (v) {
                              comment_meme = v;
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_form_key.currentState != null &&
                                  !_form_key.currentState!.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "There is something wrong with the input. Please check it out again."),
                                ));
                              } else {
                                setState(() {
                                  addCommentMeme();
                                  bacaDataComment();
                                });
                              }
                            },
                            child: Icon(Icons.send))
                      ],
                    ))
              ]))),
    );
  }
}
