import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_shop/model/globals.dart' as globals;
import 'package:flutter_shop/model/payment.dart';
import 'package:flutter_shop/ui/txn_fail.dart';
import 'package:flutter_shop/ui/txn_suc.dart';
import 'package:flutter_shop/view/Assets.dart';

class ShippingDetails extends StatefulWidget {
  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

bool edit = false;

class _ShippingDetailsState extends State<ShippingDetails> {
  final mobilePattern = RegExp(r"^[0-9]{10}$");
  final pinPattern = RegExp(r"^[1-9][0-9]{5}$");
  Razorpay _razorpay;
  CollectionReference ref = Firestore.instance
      .collection('cartItems')
      .document(globals.shopuser.uid)
      .collection('products');
  CollectionReference orderSuccessRef = Firestore.instance
      .collection('orders')
      .document(globals.shopuser.uid)
      .collection('success');
  CollectionReference orderTransactionRef = Firestore.instance
      .collection('orders')
      .document(globals.shopuser.uid)
      .collection('transactions');

  getCart() async {
    QuerySnapshot querySnapshot = await ref.getDocuments();
    var list = querySnapshot.documents;
    list.forEach((document) {
      print(document.data['name']);
      globals.items.add({
        'id': document.data['id'],
        'name': document.data['name'],
        'image': document.data['image'],
        'price': document.data['price'],
        'qty': document.data['qty'],
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  int shipping = 0;
  RazorPayModel key = RazorPayModel();
  Map<String, dynamic> notes = Map();

  void startPayment() async {
    shipping = globals.amount > 500 ? 0 : 0;
    notes['Name'] = '${globals.shopuser.name}';
    notes['E-mail'] = '${globals.shopuser.email}';
    notes['Phone Number'] = globals.shopuser.mobile;
    notes['Items'] = '${globals.items.toString()}';
    notes['Amount'] = '${(globals.amount + shipping)}';

    Random d = Random(5);
    var options = {
      'key': key.API_KEY,
      'payment_capture': '1',
      //'order_id':'${"Razor_"+d.nextInt(9999).toString()}',
      'amount': '${(globals.amount + shipping) * 100}',
      'image': Logo,
      'name': 'Zebo Shop',
      'theme.color': '#000000',
      'description': 'Zebo Transaction',
      'prefill': {
        'contact': '${globals.shopuser.mobile}',
        'email': '${globals.shopuser.email}'
      },
      'notes': notes
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
      Fluttertoast.showToast(msg: "Unexpected Error ", timeInSecForIos: 4);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  DocumentSnapshot amountN;
  DocumentReference amountReference =
      Firestore.instance.collection('cartItems').document(globals.shopuser.uid);

  getAmount() async {
    DocumentSnapshot amountOnServer = await amountReference.get();

    if (amountOnServer.exists) {
      setState(() {
        amountN = amountOnServer;
        globals.amount = amountOnServer.data['amount'];
      });
    }
  }

  void _clearCart() async {
    ref.getDocuments().then((E) {
      E.documents.forEach((F) {
        ref.document(F.documentID).delete();
      });
    });

    amountReference.setData({'amount': 0}, merge: true);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
    Map<String, dynamic> uploadtransaction = Map();
    notes.remove('Items');
    uploadtransaction['details'] = notes;
    uploadtransaction["status"] = "success";
    uploadtransaction["transaction_id"] = "${response.paymentId}";
    globals.tid = "${response.paymentId}";
    uploadtransaction["Products"] = globals.items;
    uploadtransaction["Time"] = DateTime.now();
    await orderSuccessRef.add(uploadtransaction);
    await orderTransactionRef.add(uploadtransaction);
    globals.items.clear();
    notes.clear();
    await _clearCart();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TransactionSuccess();
    }));
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Map<String, dynamic> uploadtransaction = Map();
    notes.remove('Items');
    uploadtransaction['details'] = notes;
    uploadtransaction["Products"] = globals.items;
    uploadtransaction["status"] = "cancelled";
    uploadtransaction["transaction_id"] = "${response.message}";
    globals.tid = "${response.message}";
    uploadtransaction["Time"] = DateTime.now();
    DocumentReference idef = await orderTransactionRef.add(uploadtransaction);
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
    globals.items.clear();
    notes.clear();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TransactionFail();
    }));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

  TextEditingController hnoController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          setState(() {
            edit = false;
          });
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red[800],
            title: Text("Shipping Address"),
          ),
          body: Builder(
            builder: (context) => SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: globals.w,
                    height: globals.h,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.asset('assets/b.png').image,
                            fit: BoxFit.fill)),
                  ),
                  edit
                      ? Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: globals.hp(40), left: globals.wp(10)),
                              width: globals.wp(340),
                              height: globals.hp(90),
                              color: Colors.transparent,
                              child: Card(
                                elevation: 15,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: globals.wp(280),
                                      child: Center(
                                        child: Text(
                                          globals.shopuser.name +
                                              "," +
                                              globals.shopuser.address,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: globals.wp(40),
                                      height: globals.wp(40),
                                      margin: EdgeInsets.only(
                                          left: globals.wp(270),
                                          top: globals.hp(15)),
                                      child: FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            edit = false;
                                          });
                                        },
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: globals.hp(30),
                            ),
                            Container(
                              color: Colors.transparent,
                              height: globals.hp(380),
                              width: globals.wp(340),
                              child: Card(
                                elevation: 15,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: globals.hp(45),
                                      padding: EdgeInsets.only(
                                          left: globals.w * 0.055555555,
                                          right: globals.w * 0.055555555),
                                      child: TextField(
                                        textAlign: TextAlign.left,
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            hintText: "Name",
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: false,
                                            contentPadding: EdgeInsets.only(
                                                top: globals.h * 0.0384615385,
                                                right:
                                                    globals.w * 0.2222222222)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: globals.hp(8),
                                    ),
                                    Container(
                                      height: globals.hp(45),
                                      padding: EdgeInsets.only(
                                          left: globals.w * 0.055555555,
                                          right: globals.w * 0.055555555),
                                      child: TextField(
                                        textAlign: TextAlign.left,
                                        controller: mobileController,
                                        decoration: InputDecoration(
                                            hintText: "Mobile",
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: false,
                                            contentPadding: EdgeInsets.only(
                                                top: globals.h * 0.0384615385,
                                                right:
                                                    globals.w * 0.2222222222)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: globals.hp(8),
                                    ),
                                    Container(
                                      height: globals.hp(45),
                                      padding: EdgeInsets.only(
                                          left: globals.w * 0.055555555,
                                          right: globals.w * 0.055555555),
                                      child: TextField(
                                        textAlign: TextAlign.left,
                                        controller: hnoController,
                                        decoration: InputDecoration(
                                            hintText: "House No. , Street",
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: false,
                                            contentPadding: EdgeInsets.only(
                                                top: globals.h * 0.0384615385,
                                                right:
                                                    globals.w * 0.2222222222)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: globals.hp(8),
                                    ),
                                    Container(
                                      height: globals.hp(45),
                                      padding: EdgeInsets.only(
                                          left: globals.w * 0.055555555,
                                          right: globals.w * 0.055555555),
                                      child: TextField(
                                        textAlign: TextAlign.left,
                                        controller: cityController,
                                        decoration: InputDecoration(
                                            hintText: " City",
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: false,
                                            contentPadding: EdgeInsets.only(
                                                top: globals.h * 0.0384615385,
                                                right:
                                                    globals.w * 0.2222222222)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: globals.hp(8),
                                    ),
                                    Container(
                                      height: globals.hp(45),
                                      padding: EdgeInsets.only(
                                          left: globals.w * 0.055555555,
                                          right: globals.w * 0.055555555),
                                      child: TextField(
                                        textAlign: TextAlign.left,
                                        controller: stateController,
                                        decoration: InputDecoration(
                                            hintText: "State",
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: false,
                                            contentPadding: EdgeInsets.only(
                                                top: globals.h * 0.0384615385,
                                                right:
                                                    globals.w * 0.2222222222)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: globals.hp(8),
                                    ),
                                    Container(
                                      height: globals.hp(45),
                                      padding: EdgeInsets.only(
                                          left: globals.w * 0.055555555,
                                          right: globals.w * 0.055555555),
                                      child: TextField(
                                        textAlign: TextAlign.left,
                                        controller: pinController,
                                        decoration: InputDecoration(
                                            hintText: "Pin",
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: false,
                                            contentPadding: EdgeInsets.only(
                                                top: globals.h * 0.0384615385,
                                                right:
                                                    globals.w * 0.2222222222)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: globals.hp(8),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(
                          margin: EdgeInsets.only(
                            top: globals.hp(40),
                            left: globals.wp(10),
                          ),
                          width: globals.wp(340),
                          height: globals.hp(90),
                          color: Colors.transparent,
                          child: Card(
                            elevation: 15,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: globals.wp(280),
                                  child: Center(
                                    child: Text(
                                      globals.shopuser.name +
                                          "," +
                                          globals.shopuser.address,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: globals.wp(40),
                                  height: globals.wp(40),
                                  margin: EdgeInsets.only(
                                      left: globals.wp(275),
                                      top: globals.hp(10)),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        edit = true;
                                      });
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.only(
                        top: globals.hp(600), left: globals.wp(135)),
                    child: FlatButton(
                      onPressed: edit
                          ? () async {
                              if (nameController.text != null &&
                                  nameController.text != '') {
                                if (mobilePattern
                                    .hasMatch(mobileController.text)) {
                                  if (hnoController.text != null &&
                                      hnoController.text != '') {
                                    if (cityController.text != null &&
                                        cityController.text != '') {
                                      if (stateController.text != null &&
                                          stateController.text != '') {
                                        if (pinPattern
                                            .hasMatch(pinController.text)) {
                                          String address = nameController.text +
                                              "\n" +
                                              mobileController.text +
                                              "\n" +
                                              hnoController.text +
                                              ", " +
                                              cityController.text +
                                              " - " +
                                              pinController.text +
                                              ", " +
                                              stateController.text;

                                          notes['Shipping Address'] = address;
                                          //await _updateAddress(address);
                                          await getCart();
                                          await startPayment();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Invalid Pin Code");
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "State can't be Empty");
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "City can't be Empty");
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "House Number And Street can't be Empty");
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Invalid Mobile Number");
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Name can't be Empty");
                              }
                            }
                          : () async {
                              notes['Shipping Address'] =
                                  globals.shopuser.address;
                              await getCart();
                              await startPayment();
                            },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    width: globals.wp(90),
                    height: globals.hp(50),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
