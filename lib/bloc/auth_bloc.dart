import 'package:bloc/bloc.dart';

class EmailBloc extends Cubit<bool> {
  EmailBloc() : super(false);

  void checking(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) emit(true);
  }
}

class PassBloc extends Cubit<bool> {
  PassBloc() : super(false);

  void checking(String password) {
    if (password.length > 7) emit(true);
  }
}
