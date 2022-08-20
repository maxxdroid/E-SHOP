import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 15),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 15),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
    ),
  );
}
