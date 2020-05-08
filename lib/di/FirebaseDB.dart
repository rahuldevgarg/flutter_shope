import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/di/AuthMech.dart' as prefix0;
import 'package:flutter_shop/view/Assets.dart';
import 'package:flutter_shop/di/AuthMech.dart';
import 'package:flutter_shop/adapters/ImageUploadMech.dart';
import 'package:flutter_shop/adapters/Result.dart';
import 'package:flutter_shop/adapters/User.dart';
Firestore db = Firestore.instance;
User mainuser = new User(uid: "Fetching...",age: 0,sex: "Fetching...",name: "Fetching...",email: "Fetching...",avtarUrl: Logo,mobile: "Fetching...",address: "Fetching...");

// Reference to a Collection
CollectionReference medHisCollectionRef = db.collection('medical_history');
CollectionReference medHisCollectionRef_debug = db.collection('medical_history_debug');

// Reference to a Collection
CollectionReference imgCollectionRef = db.collection('image_url_results');
CollectionReference imgCollectionRef_debug = db.collection('image_url_debug');
CollectionReference usersCollectionRef = db.collection('users');
DocumentReference usersProfileDocumentRef = db.collection('users').document(uid);
CollectionReference avtarCollectionRef = db.collection('user_avtar_img');



Future<User> addUser(Map<String, dynamic> data) async {
  final TransactionHandler createTransaction = (Transaction tx) async {
    final DocumentSnapshot ds = await tx.get(usersProfileDocumentRef);

    if (ds.exists) {
      await tx.update(ds.reference, data);
    } else {
      await tx.set(ds.reference, data);
    }

    return data;
  };

  return Firestore.instance.runTransaction(createTransaction).then((mapData) {
    return User.fromJson(mapData);
  }).catchError((error) {
    print('error: $error');
    return null;
  });
}

Future<bool> getUser() async{
  print("get user "+ prefix0.curUser.uid);
  print("yhatak");
  DocumentSnapshot ds =
      await Firestore.instance.collection("users").document(prefix0.curUser.uid).get();
  print("yhatak");
  bool ans=false;
      if(ds.data!=null){
        print("db user found");
        ans = true;
      }
      else{
        print("yhatakF");
        ans =  false;
      }
      return ans;
}

Future<User> getUserProfile() async {
  print("asli user "+ prefix0.curUser.uid);
  User dbuser = new User();
  DocumentSnapshot ds = await Firestore.instance.collection("users").document(prefix0.curUser.uid).get();
  dbuser = new User(uid: ds["uid"],avtarUrl: ds["avtarUrl"],age: ds["age"],name: ds["name"],email: ds["email"],sex: ds["sex"],mobile: ds["mobile"],address: ds["address"]);
  //print(dbuser.toJson().toString());
  mainuser =dbuser;
  return dbuser;
}