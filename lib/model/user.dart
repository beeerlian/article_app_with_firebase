import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const NOPOST = "noPost";
  static const EMAIL = "email";

  String? id;
  String? name;
  int? noPost;
  String? email;

  UserModel({this.name, this.id, this.email, this.noPost});

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = (snapshot.data() as dynamic)[ID];
    name = (snapshot.data() as dynamic)[NAME];
    noPost = (snapshot.data() as dynamic)[NOPOST];
    email = (snapshot.data() as dynamic)[EMAIL];
  }
}
