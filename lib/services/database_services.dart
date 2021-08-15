import 'package:cloud_firestore/cloud_firestore.dart';

DatabaseServices firestore = DatabaseServices();

class DatabaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  saveUserData(
      String uid, String username, String password, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        "id": uid,
        "username": username,
        "email": email,
        "password": password,
      },
    );
  }

}
