import 'package:cloud_firestore/cloud_firestore.dart';

class Useru {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final String bio;

  Useru({
    this.id,
    this.profileName,
    this.username,
    this.url,
    this.email,
    this.bio,
  });

  factory Useru.fromDocument(DocumentSnapshot doc) {
    return Useru(
      id:doc.id,
      email: doc['email'],
      username: doc['username'],
      url: doc['photoUrl'],
      profileName: doc['displayName'],
      bio: doc['bio'],
    );
  }
}