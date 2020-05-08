import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix1;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_shop/services/SignUp.dart';
import 'package:flutter_shop/view/Assets.dart';
import 'package:flutter_shop/di/AuthMech.dart';
import 'package:flutter_shop/utils/NetworkImage.dart';
import 'package:flutter_shop/adapters/User.dart';
import 'package:flutter_shop/di/FirebaseDB.dart';
import 'package:flutter_shop/adapters/ImageUploadMech.dart';
import 'package:flutter_shop/ui/homepage.dart';
import 'package:flutter_shop/di/globals.dart' as globals;
import 'package:email_validator/email_validator.dart';

TextEditingController firstNameController = new TextEditingController();
TextEditingController lastNameController = new TextEditingController();
TextEditingController ageController = new TextEditingController();
TextEditingController mobileController = new TextEditingController();
TextEditingController addressController = new TextEditingController();

String userdp;
String address;
User public = new User();
File dp;
bool isEmailValid;
String sex = "N/A";
String usingTimes = "";
var time = new DateTime.now().toString();
String udp;
final agePattern = RegExp(r"^(0?[1-9]|[1-9][0-9]|[1][1-9][1-9]|200)$");
final mobilePattern = RegExp(r"^[0-9]{10}$");
ImageUploadMech imgDetails;

class FillDetails extends StatefulWidget {
  @override
  _FillDetailsState createState() => _FillDetailsState();
}

class _FillDetailsState extends State<FillDetails> {
  bool _loading = false;
  var image;
  List<Sex> usingCollection = [
    Sex('male', 'Male'),
    Sex('female', 'Female'),
  ];


  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('user_avtar_images/${Path.basename(dp.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(dp);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    udp = dowurl.toString();
    print('DP Uploaded');
    userAdding();
  }
  void userAdding(){
      public.name = firstNameController.text+" "+lastNameController.text;
      public.email = curUser.email;
      public.sex = sex;
      public.age = int.parse(ageController.text);
      public.mobile = mobileController.text;
      public.avtarUrl = udp;
      public.uid = uid;
      public.address = addressController.text;
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = public.name;
      userUpdateInfo.photoUrl = public.avtarUrl;
      curUser.updateProfile(userUpdateInfo);
      addUser(public.toJson()).whenComplete(navigation());
      //navigation();
  }

  Future getCameraImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      dp = image;
    });
  }

  Future getGalleryImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      dp = image;
    });
  }

  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: prefix0.Stack(
        children: <Widget>[
          Container(
            height: globals.h,
            width: globals.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/b.png'), fit: BoxFit.fill),
            ),
          ),

          prefix0.Container(
            margin: prefix0.EdgeInsets.only(top:15),
            height: 150,
            width: globals.w,
            child: prefix0.Center(
              child: CircleAvatar(
                child: PNetworkImage(Logo),
                maxRadius: 35,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),

          Container(
              padding: EdgeInsets.only(
                  top: globals.h * 0.28205128,
                  right: globals.w * 0.125,
                  left: globals.w * 0.125),
              child: SizedBox(
                width: globals.w * 0.75,
                height: globals.h * 0.55,
                child: Card(
                  color: Colors.white,
                  elevation: 35,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(globals.w*0.0277777777*2)),
                  child: Column(
                    children: <Widget>[
                      prefix0.SizedBox(
                        height: 55,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: globals.w * 0.055555555,
                            right: globals.w * 0.055555555),
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: firstNameController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black26,
                                ),
                                padding: EdgeInsets.only(
                                    top: globals.h * 0.0320512821,
                                    right: globals.w * 0.069444444),
                              ),
                              hintText: "First Name",
                              hintStyle: TextStyle(color: Colors.black26),
                              filled: false,
                              contentPadding: EdgeInsets.only(
                                  top: globals.h * 0.0384615385,
                                  right: globals.w * 0.2222222222)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: globals.w * 0.055555555,
                            right: globals.w * 0.055555555),
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: lastNameController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black26,
                                ),
                                padding: EdgeInsets.only(
                                    top: globals.h * 0.0320512821,
                                    right: globals.w * 0.069444444),
                              ),
                              hintText: "Last Name",
                              hintStyle: TextStyle(color: Colors.black26),
                              filled: false,
                              contentPadding: EdgeInsets.only(
                                  top: globals.h * 0.0384615385,
                                  right: globals.w * 0.2222222222)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: globals.w * 0.055555555,
                            right: globals.w * 0.055555555),
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: mobileController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.black26,
                                ),
                                padding: EdgeInsets.only(
                                    top: globals.h * 0.0320512821,
                                    right: globals.w * 0.069444444),
                              ),
                              hintText: "Phone",
                              hintStyle: TextStyle(color: Colors.black26),
                              filled: false,
                              contentPadding: EdgeInsets.only(
                                  top: globals.h * 0.0384615385,
                                  right: globals.w * 0.2222222222)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: globals.w * 0.055555555,
                            right: globals.w * 0.055555555),
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: ageController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                child: Icon(
                                  Icons.format_list_numbered,
                                  color: Colors.black26,
                                ),
                                padding: EdgeInsets.only(
                                    top: globals.h * 0.0320512821,
                                    right: globals.w * 0.069444444),
                              ),
                              hintText: "Age",
                              hintStyle: TextStyle(color: Colors.black26),
                              filled: false,
                              contentPadding: EdgeInsets.only(
                                  top: globals.h * 0.0384615385,
                                  right: globals.w * 0.2222222222)),
                        ),
                      ),
                      prefix0.SizedBox(
                        height: 30,
                      ),
                      Container(
                            color: Colors.white,
                            height: 45,
                            child: Row(
                              children: List.generate(usingCollection.length,
                                      (int index) {
                                    final using = usingCollection[index];
                                    return GestureDetector(
                                      onTapUp: (detail) {
                                        setState(() {
                                          usingTimes = using.identifier;
                                        });
                                        if (usingTimes == 'no') {
                                        } else if (usingTimes == 'yes') {}
                                      },
                                      child: Container(
                                        height: 43.0,
                                        color: usingTimes == using.identifier
                                            ? Colors.transparent
                                            : Colors.white,
                                        child: prefix0.Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Radio(
                                                    activeColor: Colors.grey[800],
                                                    value: using.identifier,
                                                    groupValue: usingTimes,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        usingTimes = value;
                                                      });
                                                      if (usingTimes == 'male') {
                                                        sex = "Male";
                                                      } else if (usingTimes == 'female') {
                                                        sex="Female";
                                                      }
                                                    }),
                                                Text(
                                                  using.displayContent,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  height: 0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                      Container(
                        padding: EdgeInsets.only(
                            left: globals.w * 0.055555555,
                            right: globals.w * 0.055555555),
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: addressController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                child: Icon(
                                  Icons.airline_seat_flat,
                                  color: Colors.black26,
                                ),
                                padding: EdgeInsets.only(
                                    top: globals.h * 0.0320512821,
                                    right: globals.w * 0.069444444),
                              ),
                              hintText: "Address",
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: globals.w*0.0277777777*1.7),
                              filled: false,
                              contentPadding: EdgeInsets.only(
                                  top: globals.h * 0.0384615385,
                                  right: globals.w * 0.2222222222)),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          prefix0.Container(margin: prefix0.EdgeInsets.only(top: globals.h * 0.28205128-55),
            width: globals.w,
            height: 110,
            child:  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 55.0,
                    backgroundImage: dp==null?null:Image.file(dp).image,
                    backgroundColor: Colors.grey[900],
                    child: FlatButton(
                      onPressed: () {
                        _chooseImage(context);
                      },
                      child: dp == null
                          ? Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 30,
                      )
                          : prefix0.SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: _loading
                ? Container(
              margin: prefix1.EdgeInsets.only(top: globals.h*0.80,left:globals.w*0.5-15),
              child: CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.black)),
            )
                : _proceedButton(context),
          ),
          prefix0.SizedBox(
            height: 50,
          ),
//          _buildLoginForm(context),
        ],
      ),
    );
  }

   navigation(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    return prefix0.WillPopScope(
      onWillPop: (){
        prefix0.Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return SignUp();
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _buildPageContent(context),
      ),
    );
  }

  Widget _proceedButton(BuildContext context) {
    return Container(
      height: globals.h*0.86,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          onPressed: () async {
            if(mobilePattern.hasMatch(mobileController.text) && agePattern.hasMatch(ageController.text)  && firstNameController.text!=null && lastNameController.text!="" && lastNameController.text!=null && firstNameController.text!="" && usingTimes != null && addressController.text != null && addressController.text != ""){
              print(image);
              if(image!=null){
                setState(() {
                  _loading = true;
                });
                await uploadFile();
              }else{
                Fluttertoast.showToast(
                    msg: "Please Select a profile Picture",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }
            else{
              Fluttertoast.showToast(
                  msg: "Please Enter Correct Details",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          child: Text("Proceed", style: TextStyle(color: Colors.white70)),
          color: Colors.grey[900],
        ),
      ),
    );
  }

  Future<void> _chooseImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                      child: new Text(
                        'Take a picture',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        getCameraImage();
                      }),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                  ),
                  GestureDetector(
                      child: new Text(
                        'Select from gallery',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        getGalleryImage();
                      }),
                ],
              ),
            ),
          );
        });
  }
}

class Sex {
  final String identifier;
  final String displayContent;

  Sex(this.identifier, this.displayContent);
}
