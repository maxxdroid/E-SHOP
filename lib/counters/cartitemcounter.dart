import 'package:flutter/material.dart';
import '../config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter =
      ShopApp.sharedPreferences.getStringList(ShopApp.userCartList).length - 1;
  int get count => _counter;

  Future<void> displayResult() async {
    int _counter =
        ShopApp.sharedPreferences.getStringList(ShopApp.userCartList).length -
            1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
