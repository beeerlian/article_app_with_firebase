import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:slicing_ios_article_app/services/database_services.dart';

class FirebaseApi {
  static UploadTask? uploadFile(
      {required File file, required String destination})  {
    try {
      final reference = FirebaseStorage.instance.ref(destination);

      return reference.putFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static UploadTask? uploadFileInBytes(
      {required Uint8List file, required String destination})  {
    try {
      final reference = FirebaseStorage.instance.ref(destination);

      return reference.putData(file);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

}
