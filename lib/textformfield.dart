import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final controller;
  final String errormsg;
  final String hintname;
  final bool showpassword;
  final Color hintcolor;
  MyTextFormField(
      {this.controller,
      this.errormsg,
      this.hintname,
      this.showpassword,
      this.hintcolor});

  @override
  MyTextFormFieldState createState() => MyTextFormFieldState();
}

class MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return widget.errormsg;
        }
        return null;
      },
      obscureText: widget.showpassword,
      controller: widget.controller,
      maxLines: 1,
      maxLength: 255,
      maxLengthEnforced: true,
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 100, 100, 100),
            width: 1.0,
          ),
        ),
        disabledBorder: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 1.5,
          ),
        ),
        hintText: widget.hintname,
        hintStyle: TextStyle(color: widget.hintcolor),
      ),
    );
  }
}
