import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/services/database_services.dart';
import 'package:slicing_ios_article_app/ui/home.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _InitialPage());
  }

  Widget _InitialPage() {
    TextEditingController username = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Home(user: snapshot.data);
          else
            return Column(
              children: [
                Text("Signup"),
                TextField(
                  controller: username,
                ),
                TextField(
                  controller: email,
                ),
                TextField(
                  controller: password,
                ),
                FlatButton(
                  onPressed: () async {
                    try {
                      await AuthServices.signUp(username.text.trim(),
                              email.text.trim(), password.text.trim())
                          .then(
                        (value) => firestore.saveUserData(
                          value!.uid,
                          username.text.trim(),
                          password.text.trim(),
                          email.text.trim(),
                        ),
                      );
                    } catch (e) {}
                  },
                  child: Text("Signup"),
                ),
              ],
            );
        });
  }
}
