import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:instagramclone/pages/home_screen.dart';
import 'package:instagramclone/pages/signin_screen.dart';
import 'package:instagramclone/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData
        (
        scaffoldBackgroundColor: Colors.black,
        dialogBackgroundColor: Colors.black,
        primarySwatch: Colors.grey,
        cardColor: Colors.white70,
        accentColor: Colors.black,
      ),
      home:  FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (ctx,userSnapshot){
          if(userSnapshot.hasData){
            return HomeScreen();
          }
          else{
            return SignInScreen();
          }
        },
      )
    );
  }
}