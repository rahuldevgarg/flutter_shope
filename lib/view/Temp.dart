//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:zeboai/di/globals.dart' as globals;
//
//class Temp extends StatefulWidget{
//  @override
//  _TempState createState() => _TempState();
//}
//
//class _TempState extends State<Temp>{
//
//  static Widget _row1(){
//    return Container(
//      child: Text("dcfsadfcdefeafcvdfs"),
//    );
//  }
//
//  static Widget _row2(){
//    return Container(
//      child: Text("dcfsadfcdefeafcvdfs"),
//    );
//  }
//
//  static Widget _row3(){
//    return Container(
//      child: Text("dcfsadfcdefeafcvdfs"),
//    );
//  }
//
//
//  static var Cards = <Container>[_row1(),_row2(),_row3()];
//
//  static String ans1 = "sdvbgf";
//
//  static var NewCards = List.generate(Cards.length-1, (int index){
//    return GestureDetector(
//        onTap:
//            () {
//          print(ans1);
//        },
//        child:
//        Row(
//          children: <Widget>[
//            SizedBox(
//              width: globals.wp(33),
//            ),
//            Container(
//              padding: EdgeInsets.only(left: globals.wp(20), top: globals.hp(20)),
//              height: globals.hp(380),
//              width: globals.w * 0.9 - globals.wp(30),
//              child: ListView(
//                scrollDirection: Axis.vertical,
//                children: <Widget>[
//                  Text(
//                    ans1,
//                    softWrap: true,
//                  )
//                ],
//              ),
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(globals.w*0.027777778*3.0),
//                gradient: LinearGradient(colors: [
//                  Colors.blueAccent,
//                  Colors.blue,
//                  Colors.blue[400],
//                  Colors.white
//                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
//              ),
//            ),
//            SizedBox(
//              width: globals.wp(33),
//            )
//          ],
//        ));
//  });
//
//  @override
////  Widget build(BuildContext context) {
////    // TODO: implement build
////    return Scaffold(
////      backgroundColor: Colors.white,
////      body: DefaultTabController(
////        length: NewCards.length,
////        child: Stack(
////          children: <Widget>[
////
////
////            ),
////          ],
////        ),
////      ),
////    );
////  }
//}