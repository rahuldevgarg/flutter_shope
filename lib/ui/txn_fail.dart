import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/model/globals.dart' as globals;
import 'package:flutter_shop/screens/Orders.dart';

class TransactionFail extends StatefulWidget{
  @override
  _TransactionFailState createState() => _TransactionFailState();
}

class _TransactionFailState extends State<TransactionFail>{
  @override
  Widget build(BuildContext context) {
    globals.h = MediaQuery.of(context).size.height;
    globals.w = MediaQuery.of(context).size.width;
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        body: Builder(
          builder : (context) =>
          Stack(
            children: <Widget>[
              Container(
                height: globals.hp(780),
                width: globals.wp(360),
//                color: Color.fromRGBO(255, 0, 0, 0.75),
              color: Colors.greenAccent,
              ),
              Container(
                margin: EdgeInsets.only(bottom: globals.hp(400),left: globals.wp(72),right: globals.wp(72)),
                height: globals.h*18,
                width: globals.w*0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset('images/cross_txn.png').image,
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: globals.hp(370),left: globals.wp(20)),
                child: Text("Your Order Failed with message : ${globals.tid} ",style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
                softWrap: true,),
              ),
              Container(
                margin: EdgeInsets.only(bottom: globals.hp(35)),
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return Orders();
                    }
                  ));
                },
                elevation: 10,

                child: Icon(
                  Icons.exit_to_app,
                ),
                splashColor: Colors.red,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}