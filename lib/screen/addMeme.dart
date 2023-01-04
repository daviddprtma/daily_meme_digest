import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddMeme extends StatefulWidget {
  final String user_name;
  AddMeme({Key? key, required this.user_name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddMeme();
  }
}

class _AddMeme extends State<AddMeme> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _gambar_cont = TextEditingController();
  final TextEditingController _teks_atas_cont = TextEditingController();
  final TextEditingController _teks_bawah_cont = TextEditingController();

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419103/memes/addmeme.php"),
        body: {
          'link_meme': _gambar_cont.text,
          'teks_atas': _teks_atas_cont.text,
          'teks_bawah': _teks_bawah_cont.text,
          'user_name': widget.user_name.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Successfully posted')));
      }
    } else {
      throw Exception('Failed to read API');
    }
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Your Meme'),
        ),
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        child: Text(
                          "Preview",
                          style: TextStyle(color: Colors.black),
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(_gambar_cont.text),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: 300,
                        height: 300,
                        alignment: Alignment.topCenter,
                        child: Text(
                          _teks_atas_cont.text,
                          style: TextStyle(
                              fontSize: 35,
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
                          _teks_bawah_cont.text,
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                    ),
                    onChanged: (v) {
                      setState(() {
                        _gambar_cont.text = v;
                      });
                    },
                    validator: (v) {
                      if (v == null || !Uri.parse(v).isAbsolute) {
                        return 'Image url not valid :)';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Top Text'),
                    onChanged: (v) {
                      setState(() {
                        _teks_atas_cont.text = v;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Bottom Text"),
                    onChanged: (v) {
                      setState(() {
                        _teks_bawah_cont.text = v;
                      });
                    },
                  ),
                ),
                Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState != null &&
                            !_formkey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "There's something wrong. Please check it out again.")));
                        } else {
                          submit();
                        }
                      },
                      child: const Text("Submit")),
                )
              ],
            ),
          ),
        ));
  }
}
