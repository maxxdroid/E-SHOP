import 'package:e_shop/config/config.dart';
import 'package:e_shop/dialogueBox/errordialogue.dart';
import 'package:e_shop/dialogueBox/loadingdialogue.dart';
import 'package:e_shop/store/storehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_shop/widgets/mytextfield.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  final String password = '';
  final String email = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl;
  File _imageFile;
  final picker = ImagePicker();

  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            InkWell(
              onTap: selectImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: _screenheight * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            _buildform(),
            RaisedButton(
              onPressed: uploadToStorage,
              color: Colors.lightBlue,
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 4,
              width: _screenWidth * 0.8,
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildform() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MyTextFormField(
            controller: _nameController,
            hintText: 'Name',
            data: Icons.person,
            isObscure: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please Enter name';
              } else if (_nameController.text.trim().length < 6) {
                return 'Name is too short';
              }
            },
          ),
          MyTextFormField(
              controller: _emailController,
              hintText: 'Email',
              data: Icons.email,
              isObscure: false,
              validator: (value) {
                if (_emailController.text.trim().isEmpty) {
                  return 'Enter email';
                } else if (!regExp.hasMatch(_emailController.text.trim())) {
                  return 'Add valid mail';
                }
              }),
          MyTextFormField(
            controller: _passwordController,
            hintText: 'Password',
            data: Icons.person,
            isObscure: true,
            validator: (value) {
              if (_passwordController.text.trim().isEmpty) {
                return 'Enter password';
              } else if (_passwordController.text.trim().length < 7) {
                return 'Password is too short';
              }
            },
          ),
          MyTextFormField(
            controller: _cPasswordController,
            hintText: 'Confirm Password',
            data: Icons.person,
            isObscure: true,
            validator: (value) {
              if (_cPasswordController.text.trim().isEmpty) {
                return 'Confirm password';
              } else if (_cPasswordController.text.trim() !=
                  _passwordController.text.trim()) {
                return 'Password does not match';
              }
            },
          ),
        ],
      ),
    );
  }

  Future selectImage() async {
    var tempImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(tempImage.path);
    });
  }

  Future saveUpload() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (_) {
            return ErrorAlert(
              message: 'Please Select an image File',
            );
          });
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User user;

    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((auth) {
      user = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      ErrorAlert(
        message: error,
      );
    });

    if (user != null) {
      saveUserInfotoFireStrore(user);
      Navigator.pushReplacementNamed(context, StoreHome.routeName);
    }
  }

  // displayDialogue(msg) {
  //   return showDialog(
  //       context: context,
  //       builder: (_) {
  //         return ErrorAlert(
  //           message: msg,
  //         );
  //       });
  // }

  uploadToStorage() async {
    final FormState _form = _formKey.currentState;

    if (_form.validate() == true & _imageFile.path.isNotEmpty) {
      _form.save();

      showDialog(
          context: context,
          builder: (_) {
            return LoadingAlert(
              message: 'Registering please wait...',
            );
          });

      String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child(imageFileName);
      UploadTask storageUploadTask = storageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await storageUploadTask;
      await taskSnapshot.ref.getDownloadURL().then((urlImage) {
        userImageUrl = urlImage.toString();

        _registerUser();
      });
    }
  }

  Future<void> saveUserInfotoFireStrore(User fuser) async {
    FirebaseFirestore.instance.collection('user').doc(fuser.uid).set({
      'uid': fuser.uid,
      'email': fuser.email,
      'name': _nameController.text.trim(),
      'url': userImageUrl,
      ShopApp.userCartList: ['garbageValue']
    });

    await ShopApp.sharedPreferences.setString('uid', fuser.uid);
    await ShopApp.sharedPreferences.setString(ShopApp.userEmail, fuser.email);
    await ShopApp.sharedPreferences
        .setString(ShopApp.userName, _nameController.text);
    await ShopApp.sharedPreferences
        .setString(ShopApp.userAvatarUrl, userImageUrl);
    await ShopApp.sharedPreferences
        .setStringList(ShopApp.userCartList, ['garbageValue']);
  }
}
