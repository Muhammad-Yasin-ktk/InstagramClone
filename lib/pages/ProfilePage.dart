import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/pages/EditProfilePage.dart';
import 'package:instagramclone/widgets/HeaderWidget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  var onlineUserId;

  final userRef = FirebaseFirestore.instance.collection("users");

  creatProfileTopView() {
    return FutureBuilder(
      future: userRef.doc(currentUser.uid).get(),
      builder: (ctx, dataSnapShot) {
 onlineUserId=dataSnapShot.data;
        if (!dataSnapShot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        }
        return Padding(
          padding: EdgeInsets.all(17),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(dataSnapShot.data['url']),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: createColumns("posts", 0)),
                            Expanded(child: createColumns("Followers", 0)),
                            Expanded(
                                child: createColumns("Following", 0)),
                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            createBtn(),

                          ],
                        ),

                      ],
                    ),
                  ),


                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 25),
                child: Text(onlineUserId['username'],style: TextStyle(
                    color: Colors.white,
                  fontSize: 15
                ),),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 6),
                child: Text(onlineUserId['profileName'],style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                ),),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 6),
                child: Text(onlineUserId['bio'],style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),),
              ),

            ],
          ),
        );
      },
    );
  }
  createBtn() {
//    final onlineUserId=userRef.doc(currentUser.uid);
 bool ownProfile = currentUser.uid == onlineUserId['id'];
    print('currentUser ${currentUser.uid}');
    print('onlineUserId $onlineUserId');

    if (ownProfile) {
     return Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)
        ),
        width: 220,
        height: 35,
        alignment: Alignment.center,
        child: FlatButton(
          child: Text(
            'Edit Profile',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>EditProfilePage(currentOnlineUserId:onlineUserId)));
          },
        ),
      )
    ;
  }
  }
  Column createColumns(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: 'Profile'),
      body: ListView(
        children: [
          creatProfileTopView(),
        ],
      ),
    );
  }
}
