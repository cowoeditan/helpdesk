import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk/modal/api.dart';
import 'package:helpdesk/modal/tiketOnGoingModel.dart';
import 'package:http/http.dart' as http;


class InputTiketOnGoing extends StatefulWidget {
  final TiketOnGoingModel model;
  final VoidCallback reload;
  InputTiketOnGoing(this.model, this.reload);
  @override
  _InputTiketOnGoingState createState() => _InputTiketOnGoingState();
}

class _InputTiketOnGoingState extends State<InputTiketOnGoing> {
  final _key = GlobalKey<FormState>();
  String kerusakan, detail_kerusakan, solusi;

  TextEditingController txtKerusakan, txtDetailKerusakan;

setup(){
  txtKerusakan = TextEditingController(text: widget.model.kerusakan);
  txtDetailKerusakan = TextEditingController(text: widget.model.detail_kerusakan);
}
  check(){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {

    }
  }

  submit()async{
    final response = await http.post(BaseUrl.inputTiketOnGoing, body:{
      "kerusakan" : kerusakan,
      "detail_kerusakan" : detail_kerusakan,
      "solusi" : solusi,
      "id" : widget.model.id

    });
    final data =  jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1 ) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Progres Ticket"),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              enabled: false,
              controller: txtKerusakan,
              onSaved: (e) => kerusakan = e,
              decoration: InputDecoration(labelText: "Kerusakan :"),
            ),
            TextFormField(
              enabled: false,
              controller: txtDetailKerusakan,
              onSaved: (e) => detail_kerusakan = e,
              decoration: InputDecoration(labelText: "Detail Kerusakan :"),
            ),
            TextFormField(
              onSaved: (e) => solusi = e,
              decoration: InputDecoration(labelText: "Penanganan :"),
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