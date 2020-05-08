import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_shop/di/AuthMech.dart';
import 'package:flutter_shop/services/FillDetails.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_shop/services/Login.dart';
import 'package:flutter_shop/di/globals.dart' as globals;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _loading = false;
  bool termsSelected = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController cnfpasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          _exitAlert(context);
        },
        child: Scaffold(
            body: Builder(
          builder: (context) => Stack(
            children: <Widget>[
              Container(
                height: globals.h,
                width: globals.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/b.png'), fit: BoxFit.fill),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: globals.w * 0.38, top: globals.w * 0.0277777777 * 4),
                child: Image.asset(
                  'assets/cdlogo.jpeg',
                  scale: 0.8,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(
                      top: globals.h * 0.158205128,
                      right: globals.w * 0.125,
                      left: globals.w * 0.125),
                  child: SizedBox(
                    width: globals.w * 0.75,
                    height: globals.h * 0.65,
                    child: Card(
                      color: Colors.white,
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(globals.w * 0.0277777777)),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: globals.w * 0.055555555,
                                right: globals.w * 0.055555555),
                            child: TextField(
                              textAlign: TextAlign.left,
                              controller: emailController,
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
                          Container(
                            padding: EdgeInsets.only(
                                left: globals.w * 0.055555555,
                                right: globals.w * 0.055555555),
                            child: TextField(
                              obscureText: true,
                              textAlign: TextAlign.left,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    child: Icon(
                                      Icons.vpn_key,
                                      color: Colors.black26,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: globals.h * 0.0320512821,
                                        right: globals.w * 0.069444444),
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black26),
                                  filled: false,
                                  contentPadding: EdgeInsets.only(
                                      top: globals.h * 0.0384615385,
                                      right: globals.w * 0.2222222222)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: globals.w * 0.055555555,
                                right: globals.w * 0.055555555),
                            child: TextField(
                              obscureText: true,
                              textAlign: TextAlign.left,
                              controller: cnfpasswordController,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.black26,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: globals.h * 0.0320512821,
                                        right: globals.w * 0.069444444),
                                  ),
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                      color: Colors.black26,
                                      fontSize: globals.w * 0.0277777777 * 1.3),
                                  filled: false,
                                  contentPadding: EdgeInsets.only(
                                      top: globals.h * 0.0384615385,
                                      right: globals.w * 0.2222222222)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: globals.w * 0.0277777777 * 0.5,
                                top: globals.w * 0.0277777777 * 2),
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                    activeColor: Colors.blue,
                                    checkColor: Colors.white,
                                    value: termsSelected,
                                    onChanged: (bool value) {
//                                          print(value);
                                      setState(() {
                                        termsSelected = value;
                                      });
                                    }),
                                Container(
                                  child: Text(
                                    "I agree to",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize:
                                            globals.w * 0.0277777777 * 1.5),
                                  ),
                                ),
                                Container(
                                    child: FlatButton(
                                  child: Text(
                                    "Terms and Services",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontSize:
                                            globals.w * 0.0277777777 * 1.5),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: globals.w * 0.0277777777 * 2,
                          ),
                          !_loading
                              ? _signupButton(context)
                              : CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.greenAccent)),
                          SizedBox(
                            height: globals.w * 0.0277777777 * 5,
                          ),
                          Center(
                            child: Text("Or",
                                style: TextStyle(
                                    fontSize: globals.w * 0.0277777777 * 1.9)),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: globals.w * 0.0277777777 * 4),
                            child: FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Sign In with Google\t\t",
                                    style: TextStyle(
                                        fontSize:
                                            globals.w * 0.0277777777 * 1.7),
                                  ),
                                  Image.asset(
                                    'assets/google_icon1.png',
                                    scale: 1.3,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(
                    top: globals.h * 0.802805128,
                    left: globals.w * 0.666666667),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.downToUp, child: Login()));
                  },
                  child: Image.asset(
                    'assets/back.png',
                    scale: 0.8,
                  ),
                ),
              ),
//              Container(
//                margin: EdgeInsets.only(top: globals.h * 0.89),
//                child: Image.asset(
//                  'assets/bottom.png',
//                  scale: 0.5,
//                ),
//                height: globals.h * 0.24,
//                width: globals.w,
//              )
            ],
          ),
        )));
  }

  Future<void> _exitAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(globals.w * 0.0277777777)),
          backgroundColor: Colors.white,
          content: const Text(
            'Do You want To Exit',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _signupButton(BuildContext context) {
    return SizedBox(
      height: globals.h * 0.0512820513,
      width: globals.w * 0.463888889,
      child: Card(
//                            height: globals.h * 0.0512820513,
//                            width: globals.w * 0.263888889,
        color: Colors.blue[800],
        child: !_loading
            ? FlatButton(
                onPressed: () {
                  if (EmailValidator.validate(emailController.text)) {
                    if (passwordController.text != '') {
                      if (passwordController.text ==
                          cnfpasswordController.text) {
                        if (termsSelected) {
                          setState(() {
                            _loading = true;
                          });
                          signUpWithEmail(
                              emailController.text, passwordController.text).whenComplete((){
                              if(signUpSuccess){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return FillDetails();
                                    },
                                  ),
                                );

                              }else{
                                Fluttertoast.showToast(
                                    msg: "Sign Up Failed");
                              }
                          });

                        } else {
                          Fluttertoast.showToast(
                              msg: "Please Select Terms Of Service");
                        }
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Passwords don't Match , Please Try Again"),
                          duration: Duration(seconds: 3),
                        ));
                        setState(() {
                          _loading = false;
                        });
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please Enter Your Password");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please Enter Your E-mail");
                  }
                  if (!signUpSuccess) {
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.greenAccent)),
      ),
    );
  }
}
