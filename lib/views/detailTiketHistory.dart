import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk/modal/api.dart';
import 'package:helpdesk/modal/tiketHistoryModel.dart';
import 'package:helpdesk/modal/tiketOnGoingModel.dart';
import 'package:http/http.dart' as http;


class DetailTiketHistory extends StatefulWidget {
  final TiketHistoryModel model;
  final VoidCallback reload;
  DetailTiketHistory(this.model, this.reload);
  @override
  _DetailTiketHistoryState createState() => _DetailTiketHistoryState();
}

class _DetailTiketHistoryState extends State<DetailTiketHistory> {
  final _key = GlobalKey<FormState>();
  String kerusakan, detail_kerusakan, solusi;

  TextEditingController txtKerusakan, txtDetailKerusakan, txtSolusi;

setup(){
  txtKerusakan = TextEditingController(text: widget.model.kerusakan);
  txtDetailKerusakan = TextEditingController(text: widget.model.detail_kerusakan);
  txtSolusi = TextEditingController(text: widget.model.solusi);
}
  // check(){
  //   final form = _key.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     // submit();
  //   } else {

  //   }
  // }

  // // submit()async{
  // //   final response = await http.post(BaseUrl.detailTiketHistory, body:{
  // //     "kerusakan" : kerusakan,
  // //     "detail_kerusakan" : detail_kerusakan,
  // //     "solusi" : solusi,
  // //     "id" : widget.model.id

  // //   });
  //   final data =  jsonDecode(response.body);
  //   int value = data['value'];
  //   String pesan = data['message'];

  //   if (value == 1 ) {
  //     setState(() {
  //       widget.reload();
  //       Navigator.pop(context);
  //     });
  //   } else {
  //     print(pesan);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
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
              enabled: false,
              controller: txtKerusakan,
              onSaved: (e) => kerusakan = e,
              decoration: InputDecoration(labelText: "Kerusakan"),
            ),
            TextFormField(
              enabled: false,
              controller: txtDetailKerusakan,
              onSaved: (e) => detail_kerusakan = e,
              decoration: InputDecoration(labelText: "Detail Kerusakan"),
            ),
            TextFormField(
              enabled: false,
              controller: txtDetailKerusakan,
              onSaved: (e) => solusi = e,
              decoration: InputDecoration(labelText: "Solusi"),
            ),
            // Image.network(
            //             'http://192.168.10.27/api_helpdesk/upload/' + x.image,
            //             width: 100.0,
            //             height: 100,
            //             fit: BoxFit.cover,
            //           ),
            //           SizedBox(
            //             width: 10.0,
            //           ),
          ],
        ),
      ),
    );
  }
}