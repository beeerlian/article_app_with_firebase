import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/model/user.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/services/firebase_api.dart';

DatabaseServices firestore = DatabaseServices();

class DatabaseServices {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  saveUserData(
      String uid, String username, String password, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        "id": uid,
        "username": username,
        "email": email,
        "password": password,
        "noPost": 0
      },
    ).then((value) async {
      final userdata =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userActive = UserModel.fromSnapshot(userdata);
    });
  }

  saveArticle(
      {required String title,
      required String body,
      required String url,
      required int noPost,
      required String authorEmail}) async {
    await FirebaseFirestore.instance
        .collection("articles")
        .doc("${authorEmail}_post" + (noPost + 1).toString())
        .set({
      "title": title,
      "body": body,
      "datePost": DateTime.now(),
      "image": url,
      "author": authorEmail
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userActive!.id)
          .update(
        {
          'noPost': userActive!.noPost! + 1,
        },
      );
    });
  }
}
