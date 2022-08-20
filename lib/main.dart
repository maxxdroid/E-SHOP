import 'dart:async';
import 'package:e_shop/admin/adminLogin.dart';
import 'package:e_shop/counters/cartitemcounter.dart';
import 'package:e_shop/counters/change_address.dart';
import 'package:e_shop/counters/item_quantity.dart';
import 'package:e_shop/counters/total_amount_counter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './authentication/authentication.dart';
import './store/storehome.dart';
import './config/config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ShopApp.sharedPreferences = await SharedPreferences.getInstance();
  ShopApp.auth = FirebaseAuth.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => CartItemCounter()),
          ChangeNotifierProvider(create: (c) => AddressChanger()),
          ChangeNotifierProvider(create: (c) => ItemQuantity()),
          ChangeNotifierProvider(create: (c) => TotalAmount()),
        ],
        child: MaterialApp(
          home: Screen(),
          debugShowCheckedModeBanner: false,
          routes: {
            StoreHome.routeName: (ctx) => StoreHome(),
            AdminLogIn.routeName: (ctx) => AdminLogIn(),
            AuthenticationScreen.routeName: (ctx) => AuthenticationScreen(),
          },
        ));
  }
}

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

//Timer to help display LOGO and stuff like that
  displaySplash() {
    Timer(Duration(seconds: 5), () async {
      if (ShopApp.auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticationScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.amber, Colors.grey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(10.0, 0.0),
              stops: [0.0, 0.1],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/welcome2.jpg'),
              SizedBox(
                height: 30.00,
              ),
              Text(
                'Welcome to Nick Online',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
