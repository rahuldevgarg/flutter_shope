import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_shop/model/globals.dart' as globals;
import 'package:flutter_shop/model/products.dart';
import 'package:flutter_shop/screens/product_detail.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[800],
        title: Text("Favorites"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('favorites').document(globals.shopuser.uid).collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Card(
                    elevation: 10.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.asset(
                          "${document.data['image']}",
                        ),
                        title: Text("${document.data['name']}"),
                        subtitle: Text("₹ ${document.data['price']}"),
                        trailing: IconButton(
                          color: liked ? Colors.grey : Colors.red,
                          icon: liked
                              ? Icon(
                                  Icons.favorite_border,
                                )
                              : Icon(Icons.favorite),
                          onPressed: () async {
                            setState(() {
                              // liked = !liked;
                              Firestore.instance
                                  .collection("favorites").document(globals.shopuser.uid).collection('products')
                                  .document(document.documentID)
                                  .delete();
                            });
                            Fluttertoast.showToast(
                                msg: "Removed From Favorites",
                                toastLength: Toast.LENGTH_LONG);
                          },
                        ),
                      onTap: (){
                        Products _products = Products();
                        int id=0;
                          for(int i = 0 ;i<_products.products.length;i++) {
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
                                    productDetailsId: _products.products[id]['id'],
                                    productDetailsName: _products.products[id]['name'],
                                    productDetailsImage: _products.products[id]['image'],
                                    productDetailsoldPrice: _products.products[id]['oldPrice'],
                                    productDetailsPrice: _products.products[id]['price'],
                                    productDetailsDesc: _products.products[id]['prodDesc'],
                                    productDetailsQty: 0,
                                  ),
                                ),);

                      },),
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
    );
  }
}
