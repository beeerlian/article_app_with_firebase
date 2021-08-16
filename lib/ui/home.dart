import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/streamcontroller/stream_page_controller.dart';

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
        actions: [
          (userActive == null)
              ? Text("login")
              : Text(
                  userActive!.email.toString() + userActive!.noPost.toString())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          StreamState.move(StateEvent.to_upload);
        },
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('articles').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, i) {
                            DocumentSnapshot docs = snapshot.data!.docs[i];
                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 100,
                              width: 170,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: docs['image'] != null
                                        ? Image.network(
                                            docs['image'],
                                            fit: BoxFit.cover,
                                          )
                                        : Placeholder(),
                                  ),
                                  Text(docs['title']),
                                  Text(docs['author'])
                                ],
                              ),
                            );
                          }),
                    ),
                    for (int i = 0; i < snapshot.data!.size; i++)
                      SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: snapshot.data!.docs[i]['image'] != null
                                  ? Image.network(
                                      snapshot.data!.docs[i]['image'],
                                      fit: BoxFit.cover,
                                    )
                                  : Placeholder(),
                            ),
                            Expanded(
                                flex: 3,
                                child: Text(snapshot.data!.docs[i]['title']))
                          ],
                        ),
                      )
                  ],
                ),
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
