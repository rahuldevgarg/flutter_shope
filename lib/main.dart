import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shop/di/AuthMech.dart';
import 'package:flutter_shop/services/Delivery.dart';
import 'package:flutter_shop/services/Login.dart';
import 'package:flutter_shop/ui/homepage.dart';
import 'package:flutter_shop/di/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:app_settings/app_settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new SplashScreen());
  });
}

final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser boy;

bool isOnline = false;

bool exists;

class SplashScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shop',
      debugShowCheckedModeBanner: true,
      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            boy = snapshot.data;
            print(snapshot.data);
            print(boy.uid);
            setUID(boy.uid, boy);
            exists = true;
            return DealScreen();
          } else {
            exists = false;
            return DealScreen();
          }
        },
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/login': (BuildContext context) => new Login(),
        '/intro': (BuildContext context) => new Delivery()
      },
    );
  }
}

class DealScreen extends StatefulWidget {
  @override
  _DealScreenState createState() => new _DealScreenState();
}

class _DealScreenState extends State<DealScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (!_seen) {
      await prefs.setBool('seen', true);
      globals.first = true;
    } else {
      globals.first = false;
    }
  }

  startTime() async {
    print("ha bhai hum chl gye hein ");
    var _duration = new Duration(milliseconds: 1000);

    return new Timer(
        _duration,
        isOnline
            ? navigationPage
            : () {
          print("not navigating");
        });
  }

  void navigationPage() {

    if (exists) {
      if (globals.first) {
        Navigator.of(context).pushReplacementNamed('/intro');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    _checkStatus();
//    startTime();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    globals.hp = Screen(MediaQuery.of(context).size).hp;
    globals.wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isOnline
            ? Image.asset('assets/cdlogo.jpeg')
            : _conditionAlert(context),
      ),
    );
  }

  void _checkStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print("check status chal rhaa hai");
      print(result);
      if (result.isNotEmpty) {
        isOnline = true;
        print(isOnline);
        startTime();
      } else
        isOnline = false;
    } on SocketException catch (_) {
      print(_);
      isOnline = false;
    }
  }

  Widget _conditionAlert(BuildContext context) {
    globals.w = MediaQuery.of(context).size.width;
    globals.h = MediaQuery.of(context).size.height;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: Colors.white,
      content: const Text(
        'Please Check Your Network Settings',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Exit',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
        FlatButton(
          onPressed: () {
            AppSettings.openDataRoamingSettings();
          },
          child: Text(
            "Open Network Settings",
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        )
      ],
    );
  }
}
