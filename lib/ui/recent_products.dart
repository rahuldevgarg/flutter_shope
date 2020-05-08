import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_shop/model/products.dart';
import 'package:flutter_shop/screens/product_detail.dart';
import 'package:flutter_shop/model/globals.dart' as globals;

class RecentProducts extends StatefulWidget {
  @override
  _RecentProductsState createState() => _RecentProductsState();
}

class _RecentProductsState extends State<RecentProducts> {
  Products _products = Products();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _products.products.length,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          child: Hero(
            tag: _products.products[i]['name'].toString()+randomString(10),
            child: Material(
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      productDetailsId: _products.products[i]['id'],
                      productDetailsName: _products.products[i]['name'],
                      productDetailsImage: _products.products[i]['image'],
                      productDetailsoldPrice: _products.products[i]['oldPrice'],
                      productDetailsPrice: _products.products[i]['price'],
                      productDetailsDesc: _products.products[i]['prodDesc'],
                      productDetailsQty: 1,
                    ),
                  ),
                ),
                child: GridTile(
                  child: Image.asset(
                    _products.products[i]['image'],
                    fit: BoxFit.cover,
                  ),
                  footer: Container(
                    height: 30.0,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: globals.wp(110),
                            child: Text(
                            "${_products.products[i]['name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            softWrap: true,),),
                          Text(
                            "₹ ${_products.products[i]['price']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}
