import 'package:flutter/material.dart';
import 'package:flutter_shop/services/custom/IntroSlider.dart';
import 'package:flutter_shop/ui/homepage.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "SCAN",
        pathImage: "assets/illustration1.png",
        backgroundColor: Colors.transparent,
      ),
    );
    slides.add(
      new Slide(
        title: "DETECT",
        pathImage: "assets/illustration2.png",
        backgroundColor: Colors.transparent,
      ),
    );
    slides.add(
      new Slide(
        title: "DELIVERED",
        pathImage: "assets/illustration3.png",
        backgroundColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/b.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          IntroSlider(
            colorActiveDot: Colors.orange,
            slides: this.slides,
            onDonePress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return HomePage();
                  },
                ),
              );
            },
            onSkipPress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return HomePage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
