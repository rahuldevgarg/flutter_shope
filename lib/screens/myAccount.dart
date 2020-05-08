import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/adapters/User.dart';
import 'package:flutter_shop/di/FirebaseDB.dart';
import 'package:flutter_shop/di/AuthMech.dart';
class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  User currentUser = mainuser;

  @override
  void initState() {
    super.initState();
  }

  String userName() {
    if (currentUser != null) {
      if (currentUser.name == null) {
        return currentUser.email.replaceAll('@gmail.com', '');
      }
      return currentUser.name;
    } else {
      return "";
    }
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "Guest User";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[800],
        title: Text("MyAccount"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 20.0),
              child: Text(
                "Login & Security",
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              elevation: 5.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      "Name:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      "${userName()}",
                    ),
                  ),
                  Divider(
                    height: 2.0,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      "Email:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      "${email()}",
                    ),
                  ),
                  Divider(
                    height: 2.0,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      "Address:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      "${mainuser.address}",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: FlatButton(
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  signOutGoogle();
                  signOut();
                  await clearPrefs().whenComplete((){
                    SystemNavigator.pop();
                  });

                },
              ),
            )

          ],
        ),
      ),
    );
  }

  TextStyle _btnStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }
}
