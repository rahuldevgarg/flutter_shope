import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/model/globals.dart' as globals;
import 'package:flutter_shop/screens/ShippingDetails.dart';

class OrderSummary extends StatefulWidget {
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}



class _OrderSummaryState extends State<OrderSummary> {
  int amount;
  DocumentReference amountReference =
  Firestore.instance.collection('cartItems').document(globals.shopuser.uid);

    getAmount() async {
    DocumentSnapshot amountOnServer = await amountReference.get();

    if (amountOnServer.exists) {
      setState(() {
        amount = amountOnServer.data['amount'];
      });
    }
  }
  @override
  void initState(){
      super.initState();
      getAmount();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      //onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[800],
          title: Text(
            "Summary",
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                margin: EdgeInsets.only(top: globals.hp(640)),
                child: Divider(
                  thickness: 5,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: globals.hp(10), left: globals.wp(10)),
                height: globals.hp(625),
                width: globals.wp(340),
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('cartItems')
                      .document(globals.shopuser.uid)
                      .collection('products')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return SizedBox(
                            height: globals.hp(80),
                            width: globals.wp(340),
                            child: Card(
                              elevation: 10.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: globals.hp(5)),
                                      height: globals.hp(70),
                                      width: globals.wp(50),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            globals.w * 0.0277777777778 * 0.6),
                                        color: Colors.blueAccent,
                                        image: DecorationImage(
                                          image: Image.asset(
                                                  "${document.data['image']}")
                                              .image,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: globals.wp(100),
                                      margin: EdgeInsets.only(
                                          left: globals.wp(70),
                                          top: globals.hp(10)),
                                      child: Text(
                                        "${document.data['name']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: globals.w *
                                                0.0277777777778 *
                                                1.5),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(margin: EdgeInsets.only(left: globals.wp(250)),
                                      child: Text(
                                        "₹ ${document.data['price']} x ${document.data['qty']} = ₹ ${document.data['price'] * document.data['qty']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                globals.w * 0.0277777777778*1.5),
                                        softWrap: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: globals.hp(648)),
                  height: globals.hp(50),
                  width: globals.wp(360),
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: globals.wp(70),
                        height: globals.hp(40),
                        margin: EdgeInsets.only(
                            left: globals.wp(20), top: globals.hp(8)),
                        child: Center(
                          child: Text("Grand Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: globals.wp(250), top: globals.hp(3)),
                        width: globals.wp(100),
                        height: globals.hp(45),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange[800]),
                        child: FlatButton(
                          child: Center(
                            child: Text(
                              "₹ " + amount.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        onPressed: (){
                          Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ShippingDetails();
                            }));
                        },),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
