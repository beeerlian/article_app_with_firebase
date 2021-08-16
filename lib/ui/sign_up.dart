import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/services/database_services.dart';
import 'package:slicing_ios_article_app/streamcontroller/stream_page_controller.dart';
import 'package:slicing_ios_article_app/ui/home.dart';
import 'package:slicing_ios_article_app/ui/widget/widgets.dart';

class OldSignUp extends StatelessWidget {
  const OldSignUp({Key? key}) : super(key: key);

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
              FlatButton(
                  onPressed: () {
                    StreamState.move(StateEvent.to_signin);
                  },
                  child: Text("SignIn"))
            ],
          );
      },
    );
  }
}

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signup"),
            StreamBuilder(
                stream: StreamState.authstatus.stream,
                builder: (context, snapshot) {
                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: username,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Username"),
                        ),
                        TextFormField(
                          validator: (val) {
                            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val as dynamic)
                                ? null
                                : null;
                            if (snapshot.data == AuthStatus.email_error)
                              return "Please Enter Correct Email";
                          },
                          controller: email,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Email"),
                        ),
                        snapshot.data == AuthStatus.email_error
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Text("Please Enter Correct Email", style: errorLogTextStyle(),),
                              )
                            : Container(),
                        TextFormField(
                          obscureText: true,
                          style: simpleTextStyle(),
                          controller: password,
                          decoration: textFieldInputDecoration("Password"),
                        ),
                        snapshot.data == AuthStatus.email_error
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Text("Enter Password 6+ characters", style: errorLogTextStyle(),),
                              )
                            : Container()
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 50,
            ),
            CustomButton(
                label: "Sign up",
                onTap: () async {
                  StreamState.emailcheck(email.text,);
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
                }),
            SizedBox(
              height: 10,
            ),
            CustomButton(
                label: "Sign In Here",
                onTap: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ),
    );
  }
}
