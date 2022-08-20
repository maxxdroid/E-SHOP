import 'package:e_shop/admin/adminLogin.dart';
import 'package:e_shop/authentication/authentication.dart';
import 'package:e_shop/config/config.dart';
import 'package:e_shop/dialogueBox/errordialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../store/storehome.dart';
import '../widgets/mytextfield.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    // double _screenWidth = MediaQuery.of(context).size.width;
    double _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: _screenheight * 0.06, bottom: _screenheight * 0.05),
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/account.png',
                // height: 240,
                // width: 240,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextFormField(
                    controller: _emailController,
                    hintText: 'Email',
                    data: Icons.email,
                    isObscure: false,
                    validator: (_) {
                      if (_emailController.text.isEmpty) {
                        return 'Please enter email';
                      } else if (!regExp.hasMatch(_emailController.text)) {
                        return 'Please enter a valid email';
                      }
                    },
                  ),
                  MyTextFormField(
                    controller: _passwordController,
                    hintText: 'Password',
                    data: Icons.person,
                    isObscure: true,
                    validator: (_) {
                      if (_passwordController.text.isEmpty) {
                        return 'Please enter password';
                      }
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final FormState _form = _formKey.currentState;
                if (_form.validate()) {
                  _emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlert(
                              message: 'Enter mail and password',
                            );
                          });
                }
              },
              // color: Colors.lightBlue,
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: _screenheight * 0.05,
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'I am an admin',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, AdminLogIn.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    User firebseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((authUser) => {firebseUser = authUser.user})
        .catchError((error) {
      Navigator.pop(context);
      errorMessage = error.toString();
    });

    if (firebseUser != null) {
      readData(firebseUser).then((value) {
        Navigator.pushReplacementNamed(context, StoreHome.routeName);
      });
    } else {
      Route route = MaterialPageRoute(builder: (c) => AuthenticationScreen());
      Navigator.pushReplacement(context, route);
      showDialog(
          context: context,
          builder: (_) {
            return ErrorAlert(
              message: errorMessage,
            );
          });
    }
  }

  Future readData(User fuser) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(fuser.uid)
        .get()
        .then((datasnaoshot) async {
      await ShopApp.sharedPreferences
          .setString('uid', datasnaoshot.data()[ShopApp.userUID]);
      await ShopApp.sharedPreferences
          .setString(ShopApp.userEmail, datasnaoshot.data()[ShopApp.userEmail]);
      await ShopApp.sharedPreferences
          .setString(ShopApp.userName, datasnaoshot.data()[ShopApp.userName]);
      await ShopApp.sharedPreferences.setString(
          ShopApp.userAvatarUrl, datasnaoshot.data()[ShopApp.userPhotoUrl]);
      List<String> cartList =
          datasnaoshot.data()[ShopApp.userCartList].cast<String>();
      await ShopApp.sharedPreferences.setStringList(
          ShopApp.userCartList, [ShopApp.userCartList, ...cartList]);
    });
  }
}
