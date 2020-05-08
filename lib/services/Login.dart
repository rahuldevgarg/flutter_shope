import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_shop/di/AuthMech.dart';
import 'package:flutter_shop/services/Delivery.dart';
import 'package:flutter_shop/services/FillDetails.dart';
import 'package:flutter_shop/di/FirebaseDB.dart';
import 'package:flutter_shop/models/ForgotPassword.dart';
import 'package:flutter_shop/services/SignUp.dart';
import 'package:flutter_shop/ui/homepage.dart';
import 'package:flutter_shop/di/globals.dart' as globals;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool userExists;

  Future ifUserExists() async {
    bool user = await getUser();
    setState(() {
      userExists = user;
    });
  }

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
                padding: EdgeInsets.only(
                    top: globals.h * 0.128205128,
                    right: globals.w * 0.125,
                    left: globals.w * 0.125),
                child: SizedBox(
                  width: globals.w * 0.75,
                  height: globals.hp(180),
                  child: Card(
                      color: Colors.white,
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: globals.hp(45),
                            padding: EdgeInsets.only(
                                left: globals.w * 0.055555555,
                                right: globals.w * 0.055555555),
                            child: TextField(
                              textAlign: TextAlign.left,
                              controller: emailController,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    child: Icon(
                                      Icons.person,
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
                            height: globals.hp(55),
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
                            height: globals.hp(55),
                            margin: EdgeInsets.only(
                                top: globals.h * 0.0128205128,
                                left: globals.w * 0.25),
                            child: FlatButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ForgotPassword();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: globals.h * 0.429487179, left: globals.w * 0.36111111),
                height: globals.h * 0.0512820513,
                width: globals.w * 0.263888889,
                color: Colors.blue[800],
                child: FlatButton(
                  onPressed: (){
                    signInWithEmail(emailController.text, passwordController.text).whenComplete((){
                                if(!loading){
                                  Fluttertoast.showToast(msg: errorMessage);
                                }
                                else{
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: HomePage()));
                                }
                              });
                  },
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                height: globals.h * 0.1,
                width: globals.w * 0.4,
                margin: EdgeInsets.only(
                    top: globals.h * 0.512820513, left: globals.w * 0.05),
                child: Divider(
                  height: globals.h * 0.0128205128,
                  thickness: 1,
                  color: Colors.grey[600],
                ),
              ),
              Container(
                height: globals.h * 0.1,
                width: globals.w * 0.1,
                margin: EdgeInsets.only(
                    top: globals.h * 0.512820513, left: globals.w * 0.45),
                child: Center(
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: globals.w * 0.06111111),
                  ),
                ),
              ),
              Container(
                height: globals.h * 0.1,
                width: globals.w * 0.4,
                margin: EdgeInsets.only(
                    top: globals.h * 0.512820513, left: globals.w * 0.55),
                child: Divider(
                  height: globals.h * 0.0128205128,
                  thickness: 1,
                  color: Colors.grey[600],
                ),
              ),
              Container(
                color: Colors.white,
                width: globals.w * 0.6,
                margin: EdgeInsets.only(
                    top: globals.h * 0.621794872, left: globals.w * 0.225),
                child: FlatButton(
                  child:  Row(
                    children: <Widget>[
                      Image.asset("assets/google-icon.png"),
                      SizedBox(
                        width: globals.w * 0.0555555555,
                      ),
                      Text("Sign in with Google"),
                    ],
                  ),
                      onPressed: () {
                        signInWithGoogle().whenComplete(() {
                          if (checkLogIn() == true) {
                            ifUserExists().whenComplete(() {
                              if (userExists) {
                                if(globals.first){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Delivery();
                                      },
                                    ),
                                  );
                                }else{
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return HomePage();
                                      },
                                    ),
                                  );
                                }

                              } else {
                                firstNameController.text = name.split(" ")[0];
                                lastNameController.text = name.split(" ")[1];
                                userdp = imageUrl;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return FillDetails();
                                    },
                                  ),
                                );
                              }
                            });
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Login Failed , Please Try Again'),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        });
                      },
                    )
              ),
              Container(
                margin: EdgeInsets.only(
                    top: globals.h * 0.698717949, left: globals.w * 0.27),
                child: Text(
                  "Don't have an account ?",
                  style: TextStyle(
                      color: Colors.black, fontSize: globals.w * 0.05),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: globals.h * 0.737179487, left: globals.w * 0.35),
                child: FlatButton(
                  onPressed: (){Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.downToUp,
                          child: SignUp()));},
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.black, fontSize: globals.w * 0.05555555),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exitAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                  color: Colors.orange,
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
                  color: Colors.orange,
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
}
