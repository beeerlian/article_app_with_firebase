import 'dart:async';

import 'package:flutter/material.dart';

enum StateEvent { to_home, to_upload, to_signin, to_signup }
enum AuthStatus { email_error, password_error }

class StreamState {
  static StreamController authstatus = StreamController();
  static StreamController state = StreamController();

  static move(StateEvent event) {
    state.sink.add(event);
  }

  static emailcheck(String? emailval) {
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailval as dynamic)
        ? null
        : authstatus.sink.add(AuthStatus.email_error);  
  }

  static passwordcheck(String? passwordvalue){
    passwordvalue!.length > 8
        ? null
        : authstatus.sink.add(AuthStatus.password_error);
  }
}
