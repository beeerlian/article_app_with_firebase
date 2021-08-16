import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Color(0xff007EF4), fontSize: 14),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff007EF4))),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff007EF4))));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Color(0xff007EF4), fontSize: 16);
}
TextStyle errorLogTextStyle() {
  return TextStyle(color: Colors.red, fontSize: 12);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

class CustomButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  const CustomButton({Key? key,required this.label, required this.onTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors:  [const Color(0xff007EF4), const Color(0xff2A75BC)],
            )),
        width: MediaQuery.of(context).size.width,
        child: Text(
          label,
          style: biggerTextStyle(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
