import 'dart:convert';
import 'dart:io';

import 'package:daily_meme_digest/class/accountMeme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

AccountMeme accountMeme = AccountMeme();

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() {
    return _SettingScreenPageState();
  }
}

class _SettingScreenPageState extends State<SettingScreen> {
  File? _gambar;
  String nama_depan_user = "";
  String nama_belakang_user = "";
  TextEditingController _nama_depan_cont = TextEditingController();
  TextEditingController _nama_belakang_cont = TextEditingController();

  void submitAccount() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/memes/160419103/editaccountmeme.php"),
        body: {
          'user_name': accountMeme.user_name,
          'first_name': nama_depan_user,
          'last_name': nama_belakang_user,
          'url_image': "https://ubaya.fun/flutter/160419103/images" +
              accountMeme.user_name +
              ".jpg"
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;

        if (_gambar == null) {
          return;
        }

        List<int> imageBytes = _gambar!.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        final response2 = await http.post(
            Uri.parse('https://ubaya.fun/flutter/160419103/uploadprofile.php'),
            body: {
              'user_name': accountMeme.user_name,
              'image': base64Image,
            });
        if (response2.statusCode == 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response2.body)));
        }

        setState(() {
          accountMeme.nama_depan = nama_depan_user;
          accountMeme.nama_belakang = nama_belakang_user;
          accountMeme.link_gambar =
              "https://ubaya.fun/flutter/160419103/images" +
                  accountMeme.user_name +
                  ".jpg";
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User successfully updated')));
      }
    } else {
      throw ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User updated fail')));
      ;
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.photo_library),
                      title: Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    if (image == null) return;
    //setState(() {
    _gambar = File(image.path);
    //});
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 20);
    if (image == null) return;
    //setState(() {
    _gambar = File(image.path);
    //});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _nama_depan_cont.text = accountMeme.nama_depan;
      _nama_belakang_cont.text = accountMeme.nama_belakang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 130,
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                  radius: 30,
                  child: _gambar != null
                      ? Image.file(_gambar!)
                      : Image.network(accountMeme.link_gambar)),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  accountMeme.nama_depan + " " + accountMeme.nama_belakang,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Active since ' + accountMeme.tanggal_daftar,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  accountMeme.user_name,
                  style: TextStyle(fontSize: 18),
                ),
                Divider(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (v) {
                      nama_depan_user = v;
                    },
                    controller: _nama_depan_cont,
                    validator: (v) {
                      if (v == null && accountMeme.nama_depan == "") {
                        v = "";
                      } else if (v == null && accountMeme.nama_depan != "") {
                        v = accountMeme.nama_depan;
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (v) {
                      nama_belakang_user = v;
                    },
                    controller: _nama_belakang_cont,
                    validator: (v) {
                      if (v == null && accountMeme.nama_belakang == "") {
                        v = "";
                      } else if (v == null && accountMeme.nama_belakang != "") {
                        v = accountMeme.nama_belakang;
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                ),
                Divider(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          submitAccount();
                        },
                        child: Text('Save Changes')),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
