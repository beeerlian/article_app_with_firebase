import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/streamcontroller/stream_page_controller.dart';
import 'package:slicing_ios_article_app/ui/login_page.dart';
import 'package:slicing_ios_article_app/ui/main_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _InitialPage(),
    );
  }

  Widget _InitialPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .snapshots() as dynamic,
              builder: (context, querysnapshot) {
                initializingUserActive(snapshot.data!.uid);
                StreamState.move(StateEvent.to_home);
                return MainState(user: snapshot.data as dynamic);
              });
        } else {
          userActive = null;
          return Login();
        }
      },
    );
  }

  void initializingUserActive(String userid) async {
    
  }
}
