import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/streamcontroller/stream_page_controller.dart';
import 'package:slicing_ios_article_app/ui/home.dart';
import 'package:slicing_ios_article_app/ui/login_page.dart';
import 'package:slicing_ios_article_app/ui/sign_up.dart';
import 'package:slicing_ios_article_app/ui/upload_article.dart';

class MainState extends StatelessWidget {
  final User? user;
  const MainState({ Key? key, required this.user }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: StreamState.state.stream ,builder: (context, snapshot){
      if(snapshot.hasError){
        return Scaffold(body: Center(child: Text("Stream State Error"),));
      }
      else{
        if(snapshot.data == StateEvent.to_home) return Home(user: user);
        else if(snapshot.data == StateEvent.to_upload) return UploadPage(user: user as dynamic);
        else if(snapshot.data == StateEvent.to_signin) return Login();
        else if (snapshot.data == StateEvent.to_signup) return SignUp();
        else return CircularProgressIndicator();
      }
      
    });
  }
}