import 'package:flutter/material.dart';

class LoadingAlert extends StatelessWidget {
  final String message;
  const LoadingAlert({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(message),
        ],
      ),
    );
  }
}
