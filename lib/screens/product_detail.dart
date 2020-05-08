import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_shop/ui/cart_product_details.dart';
import 'package:flutter_shop/ui/similar_products.dart';
import 'package:flutter_shop/model/globals.dart' as globals;

class ProductDetails extends StatefulWidget {
  final productDetailsId;
  final productDetailsName;
  final productDetailsImage;
  final productDetailsoldPrice;
  final productDetailsPrice;
  final productDetailsDesc;
  final productDetailsQty;

  ProductDetails(
      {this.productDetailsId,
        this.productDetailsName,
      this.productDetailsImage,
      this.productDetailsoldPrice,
      this.productDetailsPrice,
      this.productDetailsDesc,
      this.productDetailsQty});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  bool liked = false;
  bool inCart = false;
  String id;
  int quantity = 1;
  String s= "Qty";
  DocumentReference favReference;
  DocumentReference cartReference;
   addToFav() async {

     Map<String,dynamic> data = {
       'id':widget.productDetailsId,
       'name': widget.productDetailsName,
       'image': widget.productDetailsImage,
       'price': widget.productDetailsPrice,
       'oldPrice':widget.productDetailsoldPrice,
       'prodDesc':widget.productDetailsDesc,
       'qty':0
     };

      try{await favReference.setData(data);setState(() {

        liked = !liked;
        id = favReference.documentID;
      });
      print(favReference.documentID);
      Fluttertoast.showToast(
          msg: "Item Added to Favorites",
          toastLength: Toast.LENGTH_LONG);}
      catch(e){Fluttertoast.showToast(msg: "Network Error , Try Again");}
    }
   removeFromFav () async {
     setState(() {
       liked = !liked;
       favReference
           .delete();
     });
     Fluttertoast.showToast(
         msg: "Removed From Favorites",
         toastLength: Toast.LENGTH_LONG);
   }
  addToCart() async {

    Map<String,dynamic> data = {
      'id':widget.productDetailsId,
      'name': widget.productDetailsName,
      'image': widget.productDetailsImage,
      'price': widget.productDetailsPrice,
      'oldPrice':widget.productDetailsoldPrice,
      'prodDesc':widget.productDetailsDesc,
      'qty':widget.productDetailsQty
    };
    try{
      DocumentSnapshot prodIncart = await cartReference.get();
      DocumentReference amountReference = Firestore.instance.collection('cartItems').document(globals.shopuser.uid);
      DocumentSnapshot amount = await amountReference.get();
      if(prodIncart.exists){
        int oldQty = prodIncart.data['qty'];
        data['qty'] = oldQty+quantity;

        int oldAmount = amount.data['amount'];
        amountReference.setData({'amount':oldAmount-(prodIncart.data['price']*prodIncart.data['qty'])+(widget.productDetailsPrice*data['qty'])},merge: true);
        await cartReference.setData(data,merge: true);
        Fluttertoast.showToast(
            msg: "Product already in Cart, quantity updated !",
            toastLength: Toast.LENGTH_LONG);
      }else{
        await cartReference.setData(data);
        if(amount.exists){
          int oldAmount = amount.data['amount'];
          amountReference.setData({'amount':oldAmount+(widget.productDetailsPrice*widget.productDetailsQty)},merge: true);
        }else
        {
          amountReference.setData({'amount':widget.productDetailsPrice*widget.productDetailsQty},merge: true);
        }
        Fluttertoast.showToast(
            msg: "Product Added to Cart",
            toastLength: Toast.LENGTH_LONG);
      }



      setState(() {

        inCart = !inCart;
        id = cartReference.documentID;
      });
      print(cartReference.documentID);
    }
    catch(e){
      Fluttertoast.showToast(msg: "Network Error , Try Again.");
    }

  }
  checkIfLikedOrNot() async{
    favReference = Firestore.instance.collection('favorites').document(globals.shopuser.uid).collection('products').document(widget.productDetailsId.toString());

    DocumentSnapshot ds = await favReference.get();
    this.setState(() {
      liked = ds.exists;
    });

  }
  checkIfInCartOrNot() async{
    cartReference = Firestore.instance.collection('cartItems').document(globals.shopuser.uid).collection('products').document(widget.productDetailsId.toString());

    DocumentSnapshot ds = await cartReference.get();
    this.setState(() {
      inCart = ds.exists;
    });

  }

  @override
  void initState(){
    super.initState();
    checkIfLikedOrNot();
    checkIfInCartOrNot();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[800],
        title: Text("Zebo Shop"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartProductDetails(
                    cartProductId: widget.productDetailsId,
                    cartProductName: widget.productDetailsName,
                    cartProductImage: widget.productDetailsImage,
                    cartProductPrice: widget.productDetailsPrice,
                    cartProductQty: widget.productDetailsQty,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                child: Container(width:globals.wp(270),child: Text(
                  "${widget.productDetailsName}",
                  style: TextStyle(
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                  softWrap: true,
                ),)
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                child: IconButton(
                  color: liked ? Colors.red[800] : Colors.grey,
                  icon: liked
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: (){
                    if(liked){
                      removeFromFav();
                    }
                    else{
                      addToFav();
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 300.0,
            child: Image.asset(
              widget.productDetailsImage,
            ),
          ),
          // --------------- Size , Color ,Quantity Buttons------------------
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: <Widget>[
                      Text(s),
                      IconButton(
                        onPressed: () {
                          showPickerNumber(context);
                        },
                        icon: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ------------------- Price Details ------------------

          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Row(
              children: <Widget>[
                Text("M.R.P. :  "),
                Text(
                  " ₹ ${widget.productDetailsoldPrice*quantity}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Row(
              children: <Widget>[
                Text("Price :  "),
                Text(
                  s=="Qty"?" ₹ ${widget.productDetailsPrice*quantity}":" ₹ ${widget.productDetailsPrice} * ${quantity} = ${widget.productDetailsPrice*quantity}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Row(
              children: <Widget>[
                Text("You Save :  "),
                Text(
                  " ₹ ${(widget.productDetailsoldPrice - widget.productDetailsPrice)*quantity} Inclusive all taxes",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          //  ---------------------- Add to Cart Buttons ------------

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
            child: MaterialButton(
              textColor: Colors.white,
              padding: EdgeInsets.all(15.0),
              child: Text("Add to Cart"),
              onPressed: (){
                 addToCart();
               },
              color: Colors.red[800],
            ),
          ),

          // -------- About this Item ------------
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 20.0, bottom: 20.0),
            child: ListTile(
              title: Text(
                "About this Item",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text("${widget.productDetailsDesc}"),
              ),
            ),
          ),
          Padding(
            child: Text(
              "Similar Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
          ),
          Container(
            height: 400.0,
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SimilarProducts(),
          ),
        ],
      ),
    );
  }

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 10),
        ]),
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            quantity = value[0]+1;
            s = "Qty : "+(value[0]+1).toString();
          });
        }).showDialog(context);
  }
}
