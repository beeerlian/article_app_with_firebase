import 'package:flutter/material.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/ui/sign_up.dart';
import 'package:slicing_ios_article_app/ui/widget/widgets.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login"),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val as dynamic)
                          ? null
                          : "Please Enter Correct Email";
                    },
                    controller: email,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("Email"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val!.length > 6
                          ? null
                          : "Enter Password 6+ characters";
                    },
                    style: simpleTextStyle(),
                    controller: password,
                    decoration: textFieldInputDecoration("Password"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            CustomButton(
                label: "Sign in",
                onTap: () {
                  AuthServices.signIn(email.text, password.text);
                }),
            SizedBox(
              height: 10,
            ),
            CustomButton(
                label: "Sign Up Here",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  
  }
}
