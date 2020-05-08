import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_shop/model/globals.dart' as globals;
import 'package:flutter_shop/ui/homepage.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    globals.h = MediaQuery.of(context).size.height;
    globals.w = MediaQuery.of(context).size.width;
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return HomePage();
        }));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
          backgroundColor: Colors.red[800],
        ),
        body: Builder(
          builder: (context) => Stack(
            children: <Widget>[
              Container(
                height: globals.h,
                width: globals.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Image.asset('assets/b.png').image,
                        fit: BoxFit.fill)),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('orders')
                    .document(globals.shopuser.uid)
                    .collection('success')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        print(document['Products']);
                        List<dynamic> order = document['Products'];
                        print(order[0]['name']);
//                      Timestamp t =
                        DateTime time = document['Time'].toDate();
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              width: globals.wp(340),
                              height: globals.hp(60),
                              child: Card(
                                color: Colors.red,
                                elevation: 45,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: globals.hp(5),
                                    ),
                                    Container(
                                      child: Text(
                                        time.day.toString() +
                                            "-" +
                                            time.month.toString() +
                                            "-" +
                                            time.year.toString() +
                                            " " +
                                            time.hour.toString() +
                                            ":" +
                                            time.minute.toString() +
                                            ":" +
                                            time.second.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Transaction Id : ${document['transaction_id']}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: globals.hp(10),
                            ),
                            Container(
                              height: globals.hp(210),
                              width: globals.wp(350),
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children:
                                      List.generate(order.length, (int index) {
                                    return order.length == 1
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: globals.wp(30)),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            width: globals.wp(300),
                                            height: globals.hp(200),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: globals.wp(300),
                                            height: globals.hp(40),
                                            child: Center(
                                              child: Text(
                                                  "Item No. ${index + 1}"),
                                            ),
                                          ),
                                          Container(
                                            child: Divider(
                                              thickness: 1,
                                              color: Colors.black,
                                            ),
                                            margin: EdgeInsets.only(
                                                top: globals.hp(25)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: globals.wp(20),
                                                top: globals.hp(70)),
                                            height: globals.hp(80),
                                            width: globals.wp(80),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                                image: DecorationImage(
                                                    image: Image.asset(
                                                        order[index]
                                                        [
                                                        'image'])
                                                        .image,
                                                    fit:
                                                    BoxFit.fill)),
                                          ),
                                          Container(
                                            width: globals.wp(200),
                                            height: globals.hp(15),
                                            margin: EdgeInsets.only(
                                                top: globals.hp(80),
                                                left:
                                                globals.wp(120)),
                                            child: Text(
                                              order[index]['name'],
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 18),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                            width: globals.wp(200),
                                            height: globals.hp(15),
                                            margin: EdgeInsets.only(
                                                top: globals.hp(100),
                                                left:
                                                globals.wp(120)),
                                            child: Text(
                                              "Price : ₹ " +
                                                  order[index]
                                                  ['price']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 15),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                            width: globals.wp(200),
                                            height: globals.hp(15),
                                            margin: EdgeInsets.only(
                                                top: globals.hp(120),
                                                left:
                                                globals.wp(120)),
                                            child: Text(
                                              "Quantity : " +
                                                  order[index]['qty']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 15),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                            width: globals.wp(200),
                                            height: globals.hp(15),
                                            margin: EdgeInsets.only(
                                                top: globals.hp(140),
                                                left:
                                                globals.wp(120)),
                                            child: Text(
                                              "Total Price : ₹ " +
                                                  (order[index][
                                                  'qty'] *
                                                      order[index]
                                                      [
                                                      'price'])
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 15),
                                              softWrap: true,
                                            ),
                                          )
                                        ],
                                      ),
                                          )
                                        : Row(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                width: globals.wp(300),
                                                height: globals.hp(210),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width: globals.wp(300),
                                                      height: globals.hp(40),
                                                      child: Center(
                                                        child: Text(
                                                            "Item No. ${index + 1}"),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Colors.black,
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          top: globals.hp(25)),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: globals.wp(20),
                                                          top: globals.hp(70)),
                                                      height: globals.hp(80),
                                                      width: globals.wp(80),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: Image.asset(
                                                                      order[index]
                                                                          [
                                                                          'image'])
                                                                  .image,
                                                              fit:
                                                                  BoxFit.fill)),
                                                    ),
                                                    Container(
                                                      width: globals.wp(200),
                                                      height: globals.hp(15),
                                                      margin: EdgeInsets.only(
                                                          top: globals.hp(80),
                                                          left:
                                                              globals.wp(120)),
                                                      child: Text(
                                                        order[index]['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: globals.wp(200),
                                                      height: globals.hp(15),
                                                      margin: EdgeInsets.only(
                                                          top: globals.hp(100),
                                                          left:
                                                              globals.wp(120)),
                                                      child: Text(
                                                        "Price : ₹ " +
                                                            order[index]
                                                                    ['price']
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: globals.wp(200),
                                                      height: globals.hp(15),
                                                      margin: EdgeInsets.only(
                                                          top: globals.hp(120),
                                                          left:
                                                              globals.wp(120)),
                                                      child: Text(
                                                        "Quantity : " +
                                                            order[index]['qty']
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: globals.wp(200),
                                                      height: globals.hp(15),
                                                      margin: EdgeInsets.only(
                                                          top: globals.hp(140),
                                                          left:
                                                              globals.wp(120)),
                                                      child: Text(
                                                        "Total Price : ₹ " +
                                                            (order[index][
                                                                        'qty'] *
                                                                    order[index]
                                                                        [
                                                                        'price'])
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                        softWrap: true,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              )
                                            ],
                                          );
                                  })),
                            ),
                            Divider(
                              thickness: 5,
                              color: Colors.grey[800],
                            ),
                            SizedBox(),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}