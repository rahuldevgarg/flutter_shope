import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/di/AuthMech.dart';
import 'package:flutter_shop/di/globals.dart' as globals;

TextEditingController usernameController = new TextEditingController();

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) => Stack(children: <Widget>[
                Container(
                  height: globals.h,
                  width: globals.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/b.png'), fit: BoxFit.fill),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: globals.h * 0.128205128,
                      right: globals.w * 0.125,
                      left: globals.w * 0.125),
                  child: SizedBox(
                    width: globals.w * 0.75,
                    height: globals.h * 0.23,
                    child: Card(
                        color: Colors.white,
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: globals.w * 0.055555555,
                                right: globals.w * 0.055555555),
                            child: TextField(
                              textAlign: TextAlign.left,
                              controller: usernameController,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    child: Icon(
                                      Icons.mail,
                                      color: Colors.black26,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: globals.h * 0.0320512821,
                                        right: globals.w * 0.069444444),
                                  ),
                                  hintText: "E-mail",
                                  hintStyle: TextStyle(color: Colors.black26),
                                  filled: false,
                                  contentPadding: EdgeInsets.only(
                                      top: globals.h * 0.0384615385,
                                      right: globals.w * 0.2222222222)),
                            ),
                          ),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: globals.h * 0.429487179,
                      left: globals.w * 0.19111111),
                  height: globals.h * 0.0512820513,
                  width: globals.w * 0.63888889,
                  decoration: new BoxDecoration(color: Colors.blue[800]),
                  child: FlatButton(
                    onPressed: () {
                      try {
                        recoverPassword(usernameController.text);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Recovery Email Sent To Your Registered Mail Address.'),
                          duration: Duration(seconds: 3),
                        ));
                      } on PlatformException {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Please Enter A Valid Email Address.'),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    },
                    child: Center(
                      child: Text(
                        "Recover Password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: globals.h * 0.89),
                  child: Image.asset(
                    'assets/bottom.png',
                    scale: 0.5,
                  ),
                  height: globals.h * 0.24,
                  width: globals.w,
                )
              ])),
    );
  }
}
