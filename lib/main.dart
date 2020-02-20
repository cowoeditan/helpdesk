import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/modal/api.dart';
import 'package:login/views/history.dart';
import 'package:login/views/onGoing.dart';
import 'package:login/views/profile.dart';
import 'package:login/views/tiket.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

//kondisi login : membuat kondisi login dan tidak login
enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  //kondisi awal tidak notSignIn
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  login() async {
    //memanggil lokasi API login
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});

    final data = jsonDecode(response.body);

    //memanggil data value & message dari response API
    int value = data['value'];
    String id_userAPI = data['id_user'];
    String id_divisiAPI = data['id_divisi'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String nama_lengkapAPI = data['nama_lengkap'];
    String photoAPI = data['photo'];
    String nama_divisiAPI = data['nama_divisi'];

    //jika valuenya sama dengan 1
    if (value == 1) {
      setState(() {
        // jika berhasil status login menjadi signIn
        _loginStatus = LoginStatus.signIn;

        //panggil method savePref
        savePref(value, usernameAPI, nama_lengkapAPI, photoAPI, nama_divisiAPI,
            id_userAPI, id_divisiAPI);
      });

      // tampilkan pesan berhasil login
      print(pesan);
    } else {
      // tampilkan pesan gagal login
      print(pesan);
    }
  }

  //buat method savePref
  savePref(int value, String username, String nama_lengkap, String photo,
      String nama_divisi, String id_user, String id_divisi) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("id_user", id_user);
      preferences.setString("id_divisi", id_divisi);
      preferences.setString("username", username);
      preferences.setString("nama_lengkap", nama_lengkap);
      preferences.setString("photo", photo);
      preferences.setString("nama_divisi", nama_divisi);
      preferences.commit();
    });
  }

  //buat variabel value
  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      //jika loginStatus valuenya = 1 LoginStatus jadi signIn jika tidak notSignIn
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  //memanggil respone dengan kondisi pertama kali / dipanggil pertama kali saat aplikasi running
  @override
  void initState() {
    super.initState();
    getPref();
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  @override
  Widget build(BuildContext context) {
    //kondisi switch untuk login
    switch (_loginStatus) {

      //jika kondisinya tidak login
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Silahkan isi username";
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: showHide,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Login"),
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => Register()));
                //   },
                //   child: Text(
                //     "Buat Akun !",
                //     textAlign: TextAlign.center,
                //   ),
                // )
              ],
            ),
          ),
        );
        break;

      //jika kondisinya login
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}

// class Register extends StatefulWidget {
//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   String username, password, nama_lengkap;
//   final _key = new GlobalKey<FormState>();

//   bool _secureText = true;
//   showHide() {
//     setState(() {
//       _secureText = !_secureText;
//     });
//   }

//   check() {
//     final form = _key.currentState;
//     if (form.validate()) {
//       form.save();
//       save();
//     }
//   }

//   save() async {
//     final response = await http
//         .post("http://192.168.10.27/api_helpdesk/api/register.php", body: {
//       "nama_lengkap": nama_lengkap,
//       "username": username,
//       "password": password
//     });
//     final data = jsonDecode(response.body);
//     int value = data['value'];
//     String pesan = data['message'];
//     if (value == 1) {
//       setState(() {
//         Navigator.pop(context);
//       });
//     } else {
//       print(pesan);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Form(
//         key: _key,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: <Widget>[
//             TextFormField(
//               validator: (e) {
//                 if (e.isEmpty) {
//                   return "Silahkan isi nama lengkap";
//                 }
//               },
//               onSaved: (e) => nama_lengkap = e,
//               decoration: InputDecoration(labelText: "Nama Lengkap"),
//             ),
//             TextFormField(
//               validator: (e) {
//                 if (e.isEmpty) {
//                   return "Silahkan isi username";
//                 }
//               },
//               onSaved: (e) => username = e,
//               decoration: InputDecoration(labelText: "Username"),
//             ),
//             TextFormField(
//               obscureText: _secureText,
//               onSaved: (e) => password = e,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                       _secureText ? Icons.visibility_off : Icons.visibility),
//                   onPressed: showHide,
//                 ),
//               ),
//             ),
//             MaterialButton(
//               onPressed: () {
//                 check();
//               },
//               child: Text("Register"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "",
      nama_lengkap = "",
      nama_divisi = "",
      photo = "",
      id_user = "",
      id_divisi = "";
  TabController tabController;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama_lengkap = preferences.getString("nama_lengkap");
      nama_divisi = preferences.getString("nama_divisi");
      photo = preferences.getString("photo");
      id_user = preferences.getString("id_user");
      id_divisi = preferences.getString("id_divisi");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.lock_open),
              onPressed: () {
                signOut();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Tiket(),
            OnGoing(),
            History(),
            Profile(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(style: BorderStyle.none)),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.assignment),
              text: "Tiket",
            ),
            Tab(
              icon: Icon(Icons.assignment_turned_in),
              text: "On Going",
            ),
            Tab(
              icon: Icon(Icons.history),
              text: "History",
            ),
            Tab(
              icon: Icon(Icons.person_outline),
              text: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
