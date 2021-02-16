import 'package:flutter/material.dart';
import 'package:instagramclone/pages/signin_screen.dart';
import 'package:instagramclone/services/auth.dart';
import 'package:instagramclone/widgets/HeaderWidget.dart';
import 'package:instagramclone/widgets/ProgressWidget.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body:    Center(
        child: RaisedButton(
            onPressed: () {
              AuthMethods().signOut().then((_) => Navigator.of(context)
                  .pushReplacement(
                  MaterialPageRoute(builder: (ctx) => SignInScreen())));
            },
            child: Text('Logout')),
      ),
    );
  }
}
