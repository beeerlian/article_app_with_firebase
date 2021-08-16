import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:slicing_ios_article_app/model/user.dart';
import 'package:slicing_ios_article_app/services/database_services.dart';

UserModel? userActive;

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore store = FirebaseFirestore.instance;

  static Future<User?> signUp(
      String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? fireBaseUser = result.user;
      return fireBaseUser;
    } catch (e) {
      debugPrint("Error : " + e.toString());
      return null;
    }
  }

  static void signOut() {
    _auth.signOut();
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? fireBaseUser = result.user;
      final userdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(fireBaseUser!.uid)
          .get();
      userActive = UserModel.fromSnapshot(userdata);
      return fireBaseUser;
    } catch (e) {
      debugPrint("Error : " + e.toString());
      return null;
    }
  }
}
