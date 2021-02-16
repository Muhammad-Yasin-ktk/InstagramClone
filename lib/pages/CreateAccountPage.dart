import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagramclone/widgets/HeaderWidget.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
final scaffoldKey=GlobalKey<ScaffoldState>();
  String username;
  submitForm(){
    final form=_formKey.currentState;
    if(form.validate()){
      form.save();
      final snackbar=SnackBar(content: Text('Welcome $username'));
      scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 4),(){
        Navigator.pop(context,username);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: scaffoldKey,
      appBar: header(context, strTitle: 'Setting', disAppearBackBtn: true),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                      child: Text(
                    'Set up a username',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'UserName',
                        labelStyle: TextStyle(fontSize: 16),
                        hintText: 'user name must be atleast 5 char',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val.length < 5 || val.isEmpty) {
                          return 'user name must be atleast 5 char';
                        }
                        return null;
                      },
                      onSaved: (val) => username = val,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: submitForm,
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(0.0)),
                    child: Center(
                      child: Text(
                        'Proceed',
                      style: TextStyle(color: Colors.black,fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
