import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/services/database_services.dart';

class Home extends StatelessWidget {
  final User? user;
  const Home({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user!.uid.toString()),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () => AuthServices.signOut(),
        ),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('articleCollection')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return ListTile(
                    title: Column(
                      children: [
                        Text(documentSnapshot['title']),
                        Text(documentSnapshot['body'])
                      ],
                    ),
                  );
                },
              );
            }
            else return Container();
          },
        ),
      ),
    );
  }
}
