import 'package:flutter/material.dart';

class AddressChanger extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  displayResult(int num) {
    _counter = num;
    notifyListeners();
  }
}
