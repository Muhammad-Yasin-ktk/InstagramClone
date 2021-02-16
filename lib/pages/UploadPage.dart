import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/widgets/ProgressWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File _image;
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  takeImageWithCamera() async {
    Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 900, maxHeight: 600);

    setState(() {
      _image = image;
    });
  }

  selectImageFromGallery() async {
    Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  takeImage(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (ctx) {
          return SimpleDialog(
            title: Text(
              'New Post',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Capture Image with camera',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: takeImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  'select Image from gallary',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: selectImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  'select Image from gallary',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  _getLocation() async {
    // you can play with the accuracy as per your need. best, high, low etc
// by default forceAndroidLocationManager is false
    Position position = await getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .catchError((err) => print(err));

// this will get the coordinates from the lat-long using Geocoder Coordinates
    final coordinates = Coordinates(position.latitude, position.longitude);

// this fetches multiple address, but you need to get the first address by doing the following two codes
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(first);
    locationTextEditingController.text =
        '${first.countryName},${first.locality}';
    print('${first.countryName},${first.locality}');
    setState(() {});
  }

  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;

  //recommend declaring a reference outside the methods
  Future<String> getData() async {
    final User user = await FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return uid;
  }

  Future<DocumentSnapshot> getUser() async {
    final uid = await getData();
    return FirebaseFirestore.instance.doc("users/$uid").get();
  }

  bool uploading = false;
  String postId = Uuid().v4();

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    Im.Image image = Im.decodeImage(_image.readAsBytesSync());
    // choose the size here, it will maintain aspect ratio

    var compressedImage = new File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      _image = compressedImage;
    });
  }

  final _postRef = FirebaseFirestore.instance.collection('post');
  final reference = FirebaseStorage.instance.ref().child('Post Picture');

  Future<String> uploadImage(File image) async {
    UploadTask uploadTask = reference.child('post/ $postId.jpg').putFile(image);

    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    return url;
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressImage();
    final User user = await FirebaseAuth.instance.currentUser;
    String downloadUrl = await uploadImage(_image);

    _postRef.doc(user.uid).collection('user posts').doc(postId).set({
      "postId": postId,
      "ownerId": user.uid,
      "username": user.displayName,
      "timestamp": DateTime.now(),
      "url": downloadUrl,
      "description": descriptionTextEditingController.text,
      "location": locationTextEditingController.text,
      "likes": {}
    });
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      _image = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  Scaffold displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _image = null;
              locationTextEditingController.clear();
              descriptionTextEditingController.clear();
            });
          },
        ),
        title: Text(
          'New Post',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
              onPressed: uploading ? null : () => controlUploadAndSave(),
              child: Text(
                'Share',
                style: TextStyle(color: Colors.lightGreenAccent, fontSize: 15),
              ))
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: FileImage(_image), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  child: FutureBuilder(
                    future: getUser(),
                    builder: (_, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data['url']),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: descriptionTextEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'say Something about image',
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 36,
            ),
            title: Container(
              width: 200,
              child: TextField(
                controller: locationTextEditingController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'write the Location here....',
                    hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Container(
            height: 100,
            width: 200,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              color: Colors.green,
              onPressed: _getLocation,
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              label: Text(
                'get my current Location..',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  var imageUrl =
      'https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg';

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  color: Colors.grey,
                  size: 200,
                ),
                RaisedButton(
                  child: Text(
                    'Upload Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () => takeImage(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.green,
                ),
              ],
            ),
          )
        : displayUploadFormScreen();
  }
}
