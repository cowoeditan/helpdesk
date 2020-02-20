import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk/modal/api.dart';
import 'package:helpdesk/modal/tiketModel.dart';
import 'package:helpdesk/views/tambahTiket.dart';
import 'package:http/http.dart' as http;

class Tiket extends StatefulWidget {
  @override
  _TiketState createState() => _TiketState();
}

class _TiketState extends State<Tiket> {
  var loading = false;
  final list = new List<TiketModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _listTiket() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.tiket);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new TiketModel(
            api['id'],
            api['no_tiket'],
            api['kerusakan'],
            api['detail_kerusakan'],
            api['id_user'],
            api['id_divisi'],
            api['tgl_pembuatan'],
            api['tgl_pengerjaan'],
            api['tgl_selesai'],
            api['image']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogProses(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Ticket ini akan di proses ?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(width: 16.0),
                    InkWell(
                        onTap: () {
                          _proses(id);
                        },
                        child: Text("Yes"))
                  ],
                )
              ],
            ),
          );
        });
  }

  _proses(String id) async {
    final response = await http.post(BaseUrl.prosesTiket, body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _listTiket();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listTiket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TambahTiket(_listTiket)));
          },
        ),
        body: RefreshIndicator(
          onRefresh: _listTiket,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Image.network('http://192.168.10.27/api_helpdesk/upload/' + x.image),
                          Image.network(
                            'http://192.168.10.27/api_helpdesk/upload/' + x.image,
                            width: 100.0,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  x.no_tiket,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(x.kerusakan),
                                Text(x.tgl_pembuatan),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              dialogProses(x.id);
                            },
                            icon: Icon(Icons.gavel),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ));
  }
}
