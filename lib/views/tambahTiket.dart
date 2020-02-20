import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:helpdesk/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class TambahTiket extends StatefulWidget {
  final VoidCallback reload;
  TambahTiket(this.reload);
  @override
  _TambahTiketState createState() => _TambahTiketState();
}

class _TambahTiketState extends State<TambahTiket> {
  String kerusakan, detail_kerusakan, id_user, id_divisi;
  File _imageFile;
  final _key = new GlobalKey<FormState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_user = preferences.getString("id_user");
      id_divisi = preferences.getString("id_divisi");
    });
  }

  // _pilihGalery() async {
  //   var image = await ImagePicker.pickImage(
  //       source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
  //   setState(() {
  //     _imageFile = image;
  //   });
  // }

  _pilihKamere() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.addTiket);
      final request = http.MultipartRequest("POST", uri);
      request.fields['kerusakan'] = kerusakan;
      request.fields['detail_kerusakan'] = detail_kerusakan;
      request.fields['id_user'] = id_user;
      request.fields['id_divisi'] = id_divisi;
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          Navigator.pop(context);
        });
      } else {
        print("failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
    // final response = await http.post(BaseUrl.addTiket, body: {
    //   "kerusakan": kerusakan,
    //   "detail_kerusakan": detail_kerusakan,
    //   "id_user": id_user,
    //   "id_divisi": id_divisi
    // });
    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String pesan = data['message'];
    // if (value == 1) {
    //   print(pesan);
    //   setState(() {
    //     widget.reload();
    //     Navigator.pop(context);
    //   });
    // } else {
    //   print(pesan);
    // }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./img/placeholder.png'),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: () {
                  _pilihKamere();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            TextFormField(
              onSaved: (e) => kerusakan = e,
              decoration: InputDecoration(labelText: "Kerusakan"),
            ),
            TextFormField(
              onSaved: (e) => detail_kerusakan = e,
              decoration: InputDecoration(labelText: "Detail Kerusakan"),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
