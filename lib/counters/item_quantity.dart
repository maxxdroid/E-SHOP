import 'package:flutter/material.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItems = 0;

  int get numberOfItems => _numberOfItems;

  display(int number) {
    _numberOfItems = number;
    notifyListeners();
  }
}
