import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_shop/di/globals.dart' as globals;

class PieChart extends StatefulWidget {
  final Map<String, double> dataMap;

  //Chart values text styling
  final double chartValueFontSize;
  final Color chartValuesColor;
  final FontWeight chartValueFontWeight;
  final bool showChartValueLabel;
  final Color chartValueLabelColor;

  //Legend text styling
  final double legendFontSize;
  final Color legendFontColor;
  final FontWeight legendFontWeight;

  final double chartRadius;
  final Duration animationDuration;
  final double chartLegendSpacing;
  final bool showChartValuesInPercentage;
  final int decimalPlaces;
  final bool showChartValues;
  final bool showChartValuesOutside;
  final List<Color> colorList;
  final bool showLegends;
  final double initialAngle;
  final String fontFamily;

  static const List<Color> defaultColorList = [
    Color(0xFFff7675),
    Color(0xFF74b9ff),
    Color(0xFF55efc4),
    Color(0xFFffeaa7),
    Color(0xFFa29bfe),
    Color(0xFFfd79a8),
    Color(0xFFe17055),
    Color(0xFF00b894),
  ];

  PieChart({
    @required this.dataMap,
    this.chartValueFontWeight = FontWeight.w700,
    this.chartValueFontSize = 12.0,
    this.showChartValueLabel = false,
    this.chartValueLabelColor,
    this.legendFontSize = 14.0,
    this.legendFontColor,
    this.legendFontWeight = FontWeight.w500,
    this.chartRadius,
    this.animationDuration,
    this.chartLegendSpacing,
    this.showChartValuesInPercentage = true,
    this.showChartValues = true,
    this.showChartValuesOutside = false,
    this.chartValuesColor,
    this.colorList = defaultColorList,
    this.showLegends = true,
    this.initialAngle = 0.0,
    this.fontFamily,
    this.decimalPlaces = 0,
    Key key,
  }) : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double _fraction = 0.0;

  List<String> legendTitles;
  List<double> legendValues;

  @override
  void initState() {
    super.initState();
    initData();

    controller = AnimationController(
      duration: widget.animationDuration ?? Duration(milliseconds: 800),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curve);
    animation.addListener(() {
      setState(() {
        _fraction = animation.value;
      });
    });
    controller.forward();
  }

  void initData() {
    assert(
      widget.dataMap != null && widget.dataMap.isNotEmpty,
      "dataMap passed to pie chart cant be null or empty",
    );
    initLegends();
    initValues();
  }

  @override
  void didUpdateWidget(PieChart oldWidget) {
    //This condition isnt working oldWidget.data is giving same data as
    //new widget.
    // print(oldWidget.dataMap);
    // print(widget.dataMap);
    //if (oldWidget.dataMap != widget.dataMap) initData();
    initData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomPaint(
                  painter: PieChartPainter(
                    _fraction,
                    widget.showChartValuesOutside,
                    widget.colorList,
                    values: legendValues,
                    initialAngle: widget.initialAngle,
                    showValuesInPercentage: widget.showChartValuesInPercentage,
                    chartValuesColor: widget.chartValuesColor ??
                        Theme.of(context).textTheme.body1.color,
                    chartValueFontWeight: widget.chartValueFontWeight,
                    chartValueFontSize: widget.chartValueFontSize,
                    decimalPlaces: widget.decimalPlaces,
                    showChartValueLabel: widget.showChartValueLabel,
                    chartValueLabelColor: widget.chartValueLabelColor,
                  ),
                  child: Container(
                    height: widget.chartRadius ??
                        MediaQuery.of(context).size.width / 2.5,
                    width: widget.chartRadius ??
                        MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                ),
                widget.showLegends
                    ? SizedBox(
                        width: widget.chartLegendSpacing ?? 16.0,
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
                widget.showLegends
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: legendTitles
                                .map(
                                  (item) => Legend(
                                    item,
                                    getColor(widget.colorList,
                                        legendTitles.indexOf(item)),
                                    widget.legendFontSize,
                                    widget.legendFontColor,
                                    widget.legendFontWeight,
                                    widget.fontFamily,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
                SizedBox(
                  height: 37,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void initLegends() {
    this.legendTitles = widget.dataMap.keys.toList(growable: false);
  }

  void initValues() {
    this.legendValues = widget.dataMap.values.toList(growable: false);
  }

  Color getColor(List<Color> colorList, int index) {
    if (index > (colorList.length - 1)) {
      var newIndex = index % (colorList.length - 1);
      return colorList.elementAt(newIndex);
    } else
      return colorList.elementAt(index);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class PieChartPainter extends CustomPainter {
  List<Paint> paintList = new List();
  List<double> subParts;
  double total = 0;
  double totalAngle = math.pi * 2;
  final double initialAngle;
  final bool showValuesInPercentage;
  final bool showChartValuesOutside;
  final int decimalPlaces;
  final Color chartValuesColor;
  final FontWeight chartValueFontWeight;
  final double chartValueFontSize;
  final Color chartValueLabelColor;
  final bool showChartValueLabel;

  PieChartPainter(
    double angleFactor,
    this.showChartValuesOutside,
    List<Color> colorList, {
    List<double> values,
    this.initialAngle,
    this.showValuesInPercentage,
    this.chartValuesColor,
    this.decimalPlaces,
    this.chartValueFontWeight,
    this.chartValueFontSize,
    this.showChartValueLabel,
    this.chartValueLabelColor,
  }) {
    for (int i = 0; i < values.length; i++) {
      paintList.add(Paint()..color = getColor(colorList, i));
    }

    totalAngle = angleFactor * math.pi * 2;
    subParts = values;

    for (double value in values) {
      total = total + value;
    }
  }

  double prevAngle = 0;
  double finalAngle = 0;

  @override
  void paint(Canvas canvas, Size size) {
    prevAngle = this.initialAngle;
    finalAngle = 0;
    for (int i = 0; i < subParts.length; i++) {
      canvas.drawArc(
        new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        prevAngle,
        (((totalAngle) / total) * subParts[i]),
        true,
        paintList[i],
      );
      var factor = showChartValuesOutside ? 1.65 : 3;
      var x = (size.width / factor) *
          math.cos(prevAngle + ((((totalAngle) / total) * subParts[i]) / 2));
      var y = (size.width / factor) *
          math.sin(prevAngle + ((((totalAngle) / total) * subParts[i]) / 2));
      if (subParts.elementAt(i).toInt() != 0) {
        var name;
        if (showValuesInPercentage)
          name = (((subParts.elementAt(i) / total) * 100)
                  .toStringAsFixed(this.decimalPlaces) +
              '%');
        else
          name = subParts.elementAt(i).toStringAsFixed(this.decimalPlaces);

        drawName(canvas, name, x, y, size);
      }
      prevAngle = prevAngle + (((totalAngle) / total) * subParts[i]);
    }
  }

  Color getColor(List<Color> colorList, int index) {
    if (index > (colorList.length - 1)) {
      var newIndex = index % (colorList.length - 1);
      return colorList.elementAt(newIndex);
    } else
      return colorList.elementAt(index);
  }

  void drawName(Canvas canvas, String name, double x, double y, Size size) {
    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: chartValuesColor,
            fontSize: chartValueFontSize,
            fontWeight: chartValueFontWeight),
        text: name);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();

    if (showChartValueLabel) {
      //Draw text background box
      final rect = Rect.fromCenter(
        center: Offset((size.width / 2 + x), (size.width / 2 + y)),
        width: tp.width + 4,
        height: tp.height + 2,
      );
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(4));
      final paint = Paint()
        ..color = chartValueLabelColor ?? Colors.grey[200]
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, paint);
    }
    //Finally paint the text above box
    tp.paint(
        canvas,
        new Offset((size.width / 2 + x) - (tp.width / 2),
            (size.width / 2 + y) - (tp.height / 2)));
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.totalAngle != totalAngle;
  }
}

class Legend extends StatelessWidget {
  final String text;
  final Color color;
  final Color legendFontColor;
  final double legendFontSize;
  final FontWeight legendFontWeight;
  final String legendFontFamily;
  Legend(
    this.text,
    this.color,
    this.legendFontSize,
    this.legendFontColor,
    this.legendFontWeight,
    this.legendFontFamily,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          height: 20.0,
          width: 18.0,
          color: color,
        ),
        SizedBox(
          width: 28.0,
        ),
        Container(
          width: globals.w * 0.30,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: legendFontWeight,
              fontSize: legendFontSize,
              color: legendFontColor ?? Theme.of(context).textTheme.body1.color,
              fontFamily: legendFontFamily,
            ),
            softWrap: true,
          ),
        ),
        Container(
          color: Colors.transparent,
          width: 30,
          height: 30,
          child: IconButton(
            icon: new Image.asset('assets/i.png'),
            onPressed: () {
              _diseaseDetails(context, text);
            },
          ),
        )
      ],
    );
  }

  String detail = '\n\n\n\t\t\t\tNodule : ' +
  globals.cardData[0].toStringAsPrecision(4) +" %"+
  '\n\t\t\t\tOpen ComeDone : ' +
  globals.cardData[1].toStringAsPrecision(4) +" %"+
  '\n\t\t\t\tCyst : ' +
  globals.cardData[2].toStringAsPrecision(4) +" %"+
  '\n\t\t\t\tNormal Skin : ' +
  globals.cardData[3].toStringAsPrecision(4) +" %"+
  '\n\t\t\t\tPustule : ' +
  globals.cardData[7].toStringAsPrecision(4) +" %"+
  '\n\t\t\t\tClosed ComeDone : ' +
  globals.cardData[5].toStringAsPrecision(4) +" %"+
  '\n\t\t\t\tPapule : ' +
  globals.cardData[6].toStringAsPrecision(4) +" %"+
  '\n\t\t\t\tOthers : ' +
  globals.cardData[4].toStringAsPrecision(4)+" %";

  Future<void> _diseaseDetails(BuildContext context, String name) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        globals.data = name.split(" ");
        if (globals.data[0] == 'Nodule') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              globals.data[0],
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'Nodule acne is a severe form of acne that causes large, inflamed, and painful breakouts called acne nodules.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        } else if (globals.data[0] == 'Pustule') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              globals.data[0],
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'Pustule is a small blister or pimple on the skin containing pus.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        } else if (globals.data[0] == 'Closed') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              "Closed ComDone",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'Closed comedones are whiteheads and develops when a skin cell becomes plugged and oil is trapped within the hair follicle.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        } else if (globals.data[0] == 'Papule') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              "Papule",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'An acne papule is a type of inflamed blemish. It looks like a red bump on the skin. Papules form when there is a high break in the follicle wall.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        } else if (globals.data[0] == 'Open') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              "Open ComDone",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'Black Heads are small follicles with dilated openings to the skin allowing oxidation of debris within the follicle laeding to the black color.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        } else if (globals.data[0] == 'Cyst') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              globals.data[0],
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'Cyst is a sac-like pocket of membranous tissue that contains fluid, air, or other substances. Cysts can grow almost anywhere in your body or under your skin.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        } else if (globals.data[0] == 'Others') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              "Others",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'Facial scars come in numerous forms and may be caused by injuries, acne, burns, or surgery. Since your face is constantly exposed to the environment, scars on this part of your body may have a harder time healing.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        }
        else if (globals.data[0] == 'Normal') {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              "Normal Skin",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'This Skin part appears to be normal.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        }
        else {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            title: Text(
              globals.data[0],
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            content: Text(
              'Information Not Availalable',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: IconButton(
                  icon: new Image.asset('assets/cross.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        }
      },
    );
  }
}
