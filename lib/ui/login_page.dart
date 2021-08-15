import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/ui/sign_up.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Text("Login"),
          TextField(
            controller: email,
          ),
          TextField(
            controller: password,
          ),
          FlatButton(
            onPressed: () {
              AuthServices.signIn(email.text, password.text);
            },
            child: Text("Login"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignUp(),
                ),
              );
            },
            child: Text("SignUp"),
          ),
        ],
      ),
    );
  }
}
