import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login/modal/api.dart';
import 'package:login/modal/tiketModel.dart';
import 'package:login/views/tambahTiket.dart';
import 'package:http/http.dart' as http;

class Tiket extends StatefulWidget {
  @override
  _TiketState createState() => _TiketState();
}

class _TiketState extends State<Tiket> {
  var loading = false;
  final list = new List<TiketModel>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
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
            api['tgl_selesai']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
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
                        children: <Widget>[
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
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ));
  }
}
