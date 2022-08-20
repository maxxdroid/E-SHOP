import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  final Function validator;
  final Function onsaved;
  bool isObscure = true;

  MyTextFormField(
      {Key key,
      this.controller,
      this.onsaved,
      this.data,
      this.hintText,
      this.isObscure,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        validator: validator,
        onSaved: onsaved,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
