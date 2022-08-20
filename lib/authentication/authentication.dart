import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AuthenticationScreen extends StatefulWidget {
  static const routeName = '/authentication-Screen';
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.grey, Colors.amber],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
              ),
              centerTitle: true,
              title: Text(
                'Nick Online',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Blackchancery'),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                      icon: Icon(
                        Icons.lock,
                        // color: Colors.white,
                      ),
                      text: 'Login'),
                  Tab(
                    icon: Icon(
                      Icons.perm_contact_calendar,
                      // color: Colors.white,
                    ),
                    text: 'SignUp',
                  )
                ],
                indicatorColor: Colors.lightBlue,
                indicatorWeight: 5.0,
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amberAccent, Colors.amberAccent],
                  // begin: Alignment.topRight,
                  // end: Alignment.bottomLeft,
                ),
              ),
              child: TabBarView(
                children: [
                  LogIn(),
                  SignUp(),
                ],
              ),
            )));
  }
}
