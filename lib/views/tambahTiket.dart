import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahTiket extends StatefulWidget {
  final VoidCallback reload;
  TambahTiket(this.reload);
  @override
  _TambahTiketState createState() => _TambahTiketState();
}

class _TambahTiketState extends State<TambahTiket> {
  String kerusakan, detail_kerusakan, id_user, id_divisi;
  final _key = new GlobalKey<FormState>();

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_user = preferences.getString("id_user");
      id_divisi = preferences.getString("id_divisi");
    });
  }

  check(){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit()async{
    final response = await http.post(BaseUrl.addTiket, body: {
      "kerusakan" : kerusakan,
      "detail_kerusakan" : detail_kerusakan,
      "id_user" : id_user,
      "id_divisi" : id_divisi
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value==1) {
      print(pesan);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState(){
    super.initState();
    getPref();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              onSaved: (e) => kerusakan = e,
              decoration: InputDecoration(labelText: "Kerusakan"),
            ),
            TextFormField(
              onSaved: (e) => detail_kerusakan = e,
              decoration: InputDecoration(labelText: "Detail Kerusakan"),
            ),
            MaterialButton(
              onPressed: (){
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
