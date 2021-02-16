import 'package:flutter/material.dart';
import 'package:instagramclone/services/auth.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: GestureDetector(
          onTap: () {
            AuthMethods().signWithGoogle(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xffDB4437),
                borderRadius: BorderRadius.circular(24)),
            child: Text(
              'Sign in with Google',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
