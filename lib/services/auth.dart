import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagramclone/pages/home_screen.dart';

import 'database.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

 getCurrentUser() async {
    return  auth.currentUser;
  }

  signWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication signInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken);
    UserCredential result =
        await firebaseAuth.signInWithCredential(authCredential);
    User userDetails = result.user;
    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "id": userDetails.uid,
        "bio": "",
        "timestamp": DateTime.now(),
        "email": userDetails.email,
        'username': userDetails.email.replaceAll('@gmail.com', ''),
        "profileName": userDetails.displayName,
        "url": userDetails.photoURL
      };

      DatabaseMehods().addUserInfoToDB(userDetails.uid, userInfoMap).then((_) =>
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => HomeScreen())));
    }
  }

  Future signOut() async {
    await auth.signOut();
  }
}
