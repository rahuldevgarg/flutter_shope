import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_shop/adapters/User.dart';
import 'package:flutter_shop/di/FirebaseDB.dart';
import 'package:flutter_shop/screens/Orders.dart';
import 'package:flutter_shop/screens/contact.dart';
import 'package:flutter_shop/screens/favorites.dart';
import 'package:flutter_shop/screens/myAccount.dart';
import 'package:flutter_shop/services/FillDetails.dart' as prefix2;
import 'package:flutter_shop/ui/cart_product_details.dart';
import 'package:flutter_shop/ui/recent_products.dart';
import 'package:flutter_shop/di/AuthMech.dart';
import 'package:flutter_shop/services/FillDetails.dart';
import 'package:flutter_shop/model/globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  User _user = new User(
      uid: "Fetching...",
      age: 0,
      sex: "Fetching...",
      name: "Fetching...",
      email: "Fetching...",
      avtarUrl:
      "https://firebasestorage.googleapis.com/v0/b/zeboai-7.appspot.com/o/assets%2Favatar_round.png?alt=media&token=0bacd9c7-9d40-4884-985d-85a89b6eb9e7",
      mobile: "Fetching...",
      address: "Fetching...");

  Future getUserData() async {
    User user = await getUserProfile();
    setState(() {
      _user = user;
      globals.shopuser = user;
    });
    print(user.toJson().toString());
  }

  bool userExists;

  Future ifUserExists() async {
    bool user = await getUser();
    setState(() {
      userExists = user;
    });
  }
  @override
  void initState() {
    //super.initState();
    _loadCurrentUser().whenComplete((){
      ifUserExists().whenComplete(() {
        if (userExists) {
          getUserData();
        } else {
          firstNameController.text = name!=null?name.split(" ")[0]:"";
          lastNameController.text = name!=null?name.split(" ")[1]:"";
          setState(() {
            if (_user.sex.toLowerCase() == 'male') {
              usingTimes = 'male';
            } else if (_user.sex.toLowerCase() == 'female') {
              usingTimes = 'female';
            }
          });
          userdp = imageUrl;
        if (usingTimes == null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FillDetails();
              },
            ),
          );
        } else if (prefix2.usingTimes != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ),
          );
        }
        }
      });
    });


    super.initState();
  }

  Future _loadCurrentUser() async{
    firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String userName() {
    if (currentUser != null) {
      if (currentUser.displayName == null) {
        return currentUser.email.replaceAll('@gmail.com', '');
      }
      return currentUser.displayName;
    } else {
      return "";
    }
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "No Email Address";
    }
  }

  String photoUrl() {
    if (currentUser != null) {
      return currentUser.email[0].toUpperCase();
    } else {
      return "A";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Which is used to listen to the nearest change and provides the current state and rebuilds the widget.
    globals.h = MediaQuery.of(context).size.height;
    globals.w = MediaQuery.of(context).size.width;
    globals.shopuser = mainuser;
    return Scaffold(
      // Drawer Start
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[800],
              ),
              accountName: Text("${userName()}"),
              accountEmail: Text("${email()}"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text("${photoUrl()}",
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyAccount()));
              },
              child: _showList(
                "My Account",
                (Icons.account_box),
              ),
            ),
            // For Orders
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Orders()));
              },
              child: _showList(
                "My Orders",
                (Icons.list),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Favorites(),
                  ),
                );
              },
              child: _showList(
                "Favorites",
                (Icons.favorite),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Contact()));
              },
              child: _showList(
                "Contact",
                (Icons.contact_phone),
              ),
            ),

          ],
        ),
      ),
      // Drawer ends
      appBar: AppBar(
        titleSpacing: 2.0,
        elevation: 0,
        backgroundColor: Colors.red[800],
        title: Text("Flutter Shop"),
        // Showing Cart Icon
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartProductDetails()));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _imgCarousel(),
          // _categories(),
          // CategoryImages(),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Recent Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          //grid view
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: RecentProducts(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgCarousel() {
    return Container(
      height: 200.0,
      child: Carousel(
        overlayShadow: true,
        overlayShadowColors: Colors.black45,
        dotSize: 5.0,
        autoplay: true,
        animationCurve: Curves.bounceInOut,
        dotBgColor: Colors.transparent,
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/products/AntiAcneGel60Gms.JPG'),
          AssetImage('images/products/AntiAcneKit.jpg'),
          AssetImage('images/products/AntiAcneMintFaceWash.jpg'),
        ],
      ),
    );
  }

  Widget _showList(String s, IconData i) {
    return ListTile(
      leading: Icon(
        i,
        color: Colors.orange,
      ),
      title: Text(s),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}