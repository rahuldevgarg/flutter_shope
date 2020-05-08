import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_shop/model/globals.dart' as globals;
import 'package:flutter_shop/model/products.dart';
import 'package:flutter_shop/screens/OrderSummary.dart';
import 'package:flutter_shop/screens/product_detail.dart';

class CartProductDetails extends StatefulWidget {
  final cartProductId;
  final cartProductName;
  final cartProductImage;
  final cartProductPrice;
  final cartProductQty;

  CartProductDetails({
    this.cartProductId,
    this.cartProductName,
    this.cartProductImage,
    this.cartProductPrice,
    this.cartProductQty,
  });

  @override
  _CartProductDetailsState createState() => _CartProductDetailsState();
}

class _CartProductDetailsState extends State<CartProductDetails> {
  static const platform = const MethodChannel("razorpay_flutter");

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
  var amount = 0;
  var shipping = 0;
  DocumentSnapshot amountN;
  DocumentReference amountReference =
      Firestore.instance.collection('cartItems').document(globals.shopuser.uid);

  getAmount() async {
    DocumentSnapshot amountOnServer = await amountReference.get();

    if (amountOnServer.exists) {
      setState(() {
        amountN = amountOnServer;
        amount = amountOnServer.data['amount'];
        globals.amount = amount;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[800],
        title: Text("Cart"),
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: Image.asset('assets/b.png').image,fit: BoxFit.fill)),
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            /* Container(
              padding: EdgeInsets.all(20.0),
              child:
                  Text("Cart Subtotal (1 item): ₹ ${widget.cartProductPrice}"),
            ),*/

            Container(
              height: height / 1.3,
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
                              child: FlatButton(
                                onPressed: () {
                                  Products _products = Products();
                                  int id = 0;
                                  for (int i = 0;
                                      i < _products.products.length;
                                      i++) {
                                    if (_products.products[i]['id'] ==
                                        document.data['id']) {
                                      id = i;
                                      break;
                                    } else {
                                      continue;
                                    }
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        productDetailsId: _products.products[id]
                                            ['id'],
                                        productDetailsName:
                                            _products.products[id]['name'],
                                        productDetailsImage:
                                            _products.products[id]['image'],
                                        productDetailsoldPrice:
                                            _products.products[id]['oldPrice'],
                                        productDetailsPrice:
                                            _products.products[id]['price'],
                                        productDetailsDesc:
                                            _products.products[id]['prodDesc'],
                                        productDetailsQty: 0,
                                      ),
                                    ),
                                  );
                                },
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
                                      margin: EdgeInsets.only(
                                          left: globals.wp(70),
                                          top: globals.hp(10)),
                                      width: globals.wp(50),
                                      height: globals.hp(20),
                                      child: Text(
                                        "${document.data['name']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: globals.w *
                                                0.0277777777778 *
                                                1.1),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: globals.wp(70),
                                          top: globals.hp(35)),
                                      width: globals.wp(80),
                                      child: Text(
                                        "₹ ${document.data['price']} * ${document.data['qty']} = ${document.data['price'] * document.data['qty']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                globals.w * 0.0277777777778),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: globals.wp(170)),
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: <Widget>[
                                            Text("${document.data['qty']}"),
                                            IconButton(
                                              onPressed: () {
                                                showPickerNumber(
                                                    context, document);
                                              },
                                              icon: Icon(Icons.arrow_drop_down),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: globals.wp(20),
                                      height: globals.hp(20),
                                      margin: EdgeInsets.only(
                                          left: globals.wp(260),
                                          top: globals.hp(10)),
                                      child: IconButton(
                                        onPressed: () async {
                                          await getAmount();
                                          if (amountN.exists) {
                                            int oldAmount =
                                                amountN.data['amount'];
                                            amountReference.setData({
                                              'amount': oldAmount -
                                                  (document.data['price'] *
                                                      document.data['qty'])
                                            }, merge: true);
                                          }
                                          setState(() {
                                            print(amount);
                                            Firestore.instance
                                                .collection("cartItems")
                                                .document(globals.shopuser.uid)
                                                .collection('products')
                                                .document(document.documentID)
                                                .delete();
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Item Deleted From Cart",
                                              toastLength: Toast.LENGTH_LONG);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 12.0, bottom: 20.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                color: Colors.red[800],
                minWidth: MediaQuery.of(context).size.width,
                textColor: Colors.white,
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Proceed to Buy",
                  style: _btnStyle(),
                ),
                onPressed: () async {

                  await getAmount();
                  globals.amount!=0?
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OrderSummary();
                  })):Fluttertoast.showToast(msg: "No items in cart!",toastLength: Toast.LENGTH_SHORT);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showPickerNumber(BuildContext context, DocumentSnapshot document) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 10),
        ]),
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            _updateQuantity(value[0] + 1, document);
          });
        }).showDialog(context);
  }

  TextStyle _btnStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  void _updateQuantity(int quantity, DocumentSnapshot document) async {
    try {
      DocumentReference cartReference = Firestore.instance
          .collection('cartItems')
          .document(globals.shopuser.uid)
          .collection('products')
          .document(document.documentID);

      DocumentSnapshot prodIncart = await cartReference.get();
      DocumentReference amountReference = Firestore.instance
          .collection('cartItems')
          .document(globals.shopuser.uid);
      DocumentSnapshot amount = await amountReference.get();
      int oldQty = prodIncart.data['qty'];
      Map<String, dynamic> data = {
        'qty': quantity,
      };
      int oldAmount = amount.data['amount'];
      amountReference.setData({
        'amount': oldAmount -
            (prodIncart.data['price'] * oldQty) +
            (prodIncart.data['price'] * quantity)
      }, merge: true);
      await cartReference.setData(data, merge: true);
    } catch (e) {
      Fluttertoast.showToast(msg: "Network Error , Try Again.");
    }
  }
}
