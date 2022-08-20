import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/admin/upload_items_Dart.dart';
import 'package:e_shop/dialogueBox/loadingdialogue.dart';
import 'package:flutter/material.dart';
import '../widgets/mytextfield.dart';
import '../dialogueBox/errordialogue.dart';
import '../authentication/authentication.dart';

class AdminLogIn extends StatelessWidget {
  static const routeName = '/admin-login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Admin LogIn'),
        centerTitle: true,
      ),
      body: AdminLogInScreen(),
    );
  }
}

class AdminLogInScreen extends StatefulWidget {
  @override
  _AdminLogInScreenState createState() => _AdminLogInScreenState();
}

class _AdminLogInScreenState extends State<AdminLogInScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adminIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    {
      double _screenheight = MediaQuery.of(context).size.height;
      // double _screenHeight = MediaQuery.of(context).size.height;
      return SingleChildScrollView(
        child: Container(
          color: Colors.amberAccent,
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/account.png',
                  height: _screenheight * 0.4,
                  // width: 240,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_screenheight * 0.01),
                child: Text(
                  'Admin',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
              Container(
                // height: _screenheight * 0.3,
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyTextFormField(
                        controller: _adminIdController,
                        hintText: 'Id',
                        data: Icons.admin_panel_settings,
                        isObscure: false,
                      ),
                      MyTextFormField(
                        controller: _passwordController,
                        hintText: 'Password',
                        data: Icons.person,
                        isObscure: true,
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _adminIdController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty
                      ? loginAdmin()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlert(
                              message: 'Enter mail and password',
                            );
                          });
                },
                // color: Colors.lightBlue,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
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
                  Navigator.pushReplacementNamed(
                      context, AuthenticationScreen.routeName);
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
  }

  loginAdmin() {
    LoadingAlert(
      message: 'Logging in please wait',
    );
    FirebaseFirestore.instance
        .collection('admins')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((result) {
                if (result.data()['id'] != _adminIdController.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Your Id is not corrct')));
                  print(result.data()['id']);
                  print(_passwordController.text.trim());
                } else if (result.data()['password'] !=
                    _passwordController.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Your Password is not correct')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Welcome ' + result.data()['name'])));
                  setState(() {
                    _adminIdController.text = '';
                    _passwordController.text = '';
                  });

                  Route route = MaterialPageRoute(builder: (c) => UploadPage());
                  Navigator.pushReplacement(context, route);
                }
              })
            });
  }
}
