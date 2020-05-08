import 'package:flutter/material.dart';
import 'package:flutter_shop/model/products.dart';
import 'package:flutter_shop/screens/product_detail.dart';
import 'package:flutter_shop/di/globals.dart' as globals;

class SimilarProducts extends StatefulWidget {
  @override
  _SimilarProductsState createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  Products _product = Products();

  var _recentProducts = [];
  @override
  void initState(){
    super.initState();


    _recentProducts.add(_product.products[1]);
    _recentProducts.add(_product.products[2]);

  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _recentProducts.length,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          child: Hero(
            tag: _recentProducts[i],
            child: Material(
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        productDetailsId: _recentProducts[i]['id'],
                        productDetailsName: _recentProducts[i]['name'],
                        productDetailsImage: _recentProducts[i]['image'],
                        productDetailsoldPrice: _recentProducts[i]['oldPrice'],
                        productDetailsPrice: _recentProducts[i]['price'],
                        productDetailsDesc: _recentProducts[i]['prodDesc'],
                        productDetailsQty: 1,
                      ),
                    ),);
                },
                child: GridTile(
                  child: Image.asset(
                    _recentProducts[i]['image'],
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
                          Container(width: globals.wp(130),child: Text(
                            "${_recentProducts[i]['name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),softWrap: true,
                          ),),
                          Text(
                            "₹ ${_recentProducts[i]['price']}",
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
