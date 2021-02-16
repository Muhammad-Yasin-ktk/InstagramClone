import "package:flutter/material.dart";

class EditProfilePage extends StatefulWidget {
var  currentOnlineUserId;
  EditProfilePage({this.currentOnlineUserId});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController=TextEditingController();
  TextEditingController bioTextEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Edit Pofile',style: TextStyle(
          color: Colors.white,fontSize: 18
        ),),
      ),
    );
  }
}
