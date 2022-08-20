import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String message;
  const ErrorAlert({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      key: key,
      content: Text(
        message,
        style: TextStyle(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Center(
            child: Text('Ok'),
          ),
        )
      ],
    );
  }
}
