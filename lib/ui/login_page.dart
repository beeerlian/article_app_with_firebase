import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slicing_ios_article_app/bloc/auth_bloc.dart';
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
                    onChanged: (value) {
                      EmailBloc().checking(value);
                    },
                    controller: email,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("Email"),
                  ),
                  // BlocConsumer<EmailBloc, bool>(
                  //   listener: (context, state) {},
                  //   builder: (context, state) => state
                  //       ? Align(
                  //           alignment: Alignment.centerRight,
                  //           child: Text(
                  //             "Please Enter Correct Email",
                  //             style: errorLogTextStyle(),
                  //           ),
                  //         )
                  //       : Container(),
                  // ),
                
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      PassBloc().checking(value);
                    },
                    style: simpleTextStyle(),
                    controller: password,
                    decoration: textFieldInputDecoration("Password"),
                  ),
                  // BlocConsumer<PassBloc, bool>(
                  //   listener: (context, state) {},
                  //   builder: (context, state) => state
                  //       ? Align(
                  //           alignment: Alignment.centerRight,
                  //           child: Text(
                  //             "Password weak",
                  //             style: errorLogTextStyle(),
                  //           ),
                  //         )
                  //       : Container(),
                  // ),
                
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
