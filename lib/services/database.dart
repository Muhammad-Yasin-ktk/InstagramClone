import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMehods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userInfoMap);
  }
//
//  Future<Stream<QuerySnapshot>> getUserByUsername(String userName) async {
//    return FirebaseFirestore.instance
//        .collection("messenger")
//        .doc("5Q0FmFkSigM1HmZ2Yutt")
//        .collection("users")
//        .where('username', isEqualTo: userName)
//        .snapshots();
//  }
}
