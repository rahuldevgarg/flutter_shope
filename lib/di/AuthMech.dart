import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_shop/di/FirebaseDB.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
AuthResult authResult;
bool loading = true;
bool signUpSuccess = false;
String errorMessage ="";

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser guser = authResult.user;

  // Checking if email and name is null
  assert(guser.email != null);
  assert(guser.displayName != null);
  assert(guser.photoUrl != null);
  setUID(guser.uid, guser);
  name = guser.displayName;
  email = guser.email;
  imageUrl = guser.photoUrl;
  uid = guser.uid;

  assert(!guser.isAnonymous);
  assert(await guser.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(guser.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $guser';
}

FirebaseUser curUser;
Future<FirebaseUser> getCurrentUser() async {
  FirebaseUser user = await _auth.currentUser();
  curUser = user;
  return user;
}
String name = curUser.displayName;
String email = curUser.email;
String imageUrl = curUser.photoUrl;
String uid = curUser.uid;

 signOutGoogle() async {

  await googleSignIn.signOut();
  print("User Sign Out");
}

 signOut() async {
  await _auth.signOut();
  print("User Sign Out");
}

Future signUpWithEmail(String email,String password) async {
  FirebaseUser signupuser;
  try {
    signupuser = (await _auth.createUserWithEmailAndPassword(
      email: email, password: password,
    )).user;
    if (signupuser != null) {
      setUID(signupuser.uid, signupuser);
      print(signupuser.uid);
    }
    signUpSuccess = true;
  } catch (e) {
    signUpSuccess = false;

  }
}

Future signInWithEmail(String email,String password) async {
  print("sign in with email");
  // marked async
  FirebaseUser euser;
  try {
    euser = (await _auth.signInWithEmailAndPassword(
        email: email, password: password)).user;

    print("dealing " +euser.uid);
    if (euser != null) {
      setUID(euser.uid, euser);
    }
  } catch (e) {
      loading = false;
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Incorrect password.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        default:
          errorMessage = "Something went wrong.";
      }
  }
}

void setUID(String clientUid,FirebaseUser client){
  print("UID is $clientUid");
  uid = clientUid;
  curUser = client;

  mainuser.uid = client.uid;
}

void recoverPassword(String email){
  _auth.sendPasswordResetEmail(email: email);
}

bool checkLogIn() {
  return !(email == null);
}


String getUrl(){
  return imageUrl;
}
Future clearPrefs() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('seen');

}