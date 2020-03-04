import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:helpdesk/modal/api.dart';
import 'dart:convert';
import 'package:helpdesk/modal/tiketOnGoingModel.dart';
import 'package:helpdesk/views/inputTiketOnGoing.dart';

class OnGoing extends StatefulWidget {
  @override
  _OnGoingState createState() => _OnGoingState();
}

class _OnGoingState extends State<OnGoing> {
  var loading = false;
  final list = new List<TiketOnGoingModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _listTiket() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.tiketOnGoing);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new TiketOnGoingModel(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listTiket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Image.network(
                        'http://192.168.10.27/api_helpdesk/upload/' + x.image,
                        width: 50.0,
                        height: 50,
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
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Kerusakan : "+x.kerusakan,
                              style: TextStyle(
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "Waktu Pembuatan : "+x.tgl_pembuatan,
                              style: TextStyle(
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "Status : "+"On Progres",
                              style: TextStyle(
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  InputTiketOnGoing(x, _listTiket)));
                        },
                        icon: Icon(Icons.input),
                      ),
                    ],
                  ),
                );
              },
            ),
    ));
  }
}
