import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/dialogueBox/loadingdialogue.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_shop/admin/admin_shift_order.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();	
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;

  File _imageFile;
  final picker = ImagePicker();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _shortInfoController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return _imageFile == null ? displayAdminHomeScren() : admonUploadForm();
  }

  displayAdminHomeScren() {
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
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => Screen());
              Navigator.pushReplacement(context, route);
            },
          )
        ],
      ),
      body: adminHomeScreen(),
    );
  }

  adminHomeScreen() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.grey, Colors.amber],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.00,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.amberAccent,
                child: TextButton(
                  onPressed: () => takeImage(context),
                  child: Text(
                    'Add new Items',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future selectfromGallery() async {
    var tempImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(tempImage.path);
    });
  }

  Future captureWithCamera() async {
    var tempImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(tempImage.path);
    });
  }

  takeImage(mcontext) {
    return showDialog(
        context: mcontext,
        builder: (_) {
          return SimpleDialog(
            // titleTextStyle: TextStyle(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              'Add a Pic',
              style: TextStyle(
                  color: Colors.amberAccent, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Select from gallery',
                  style: TextStyle(color: Colors.amberAccent),
                ),
                onPressed: () {
                  selectfromGallery();
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Take a Pic',
                  style: TextStyle(color: Colors.amberAccent),
                ),
                onPressed: () {
                  captureWithCamera();
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.only(top: 10, left: 120),
                child: Text(
                  'cancel',
                  style: TextStyle(color: Colors.amberAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  admonUploadForm() {
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
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              clearFormInfo();
            }),
        title: Text('New Product'),
        actions: [
          IconButton(
            onPressed: uploading
                ? null
                : () {
                    uploadImageAndSaveItemInfo();
                  },
            icon: Icon(Icons.check_sharp),
            color: Colors.white,
          ),
        ],
      ),
      body: ListView(children: [
        Column(
          children: [
            Image.file(
              _imageFile,
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    controller: _titleController,
                    strutStyle: StrutStyle(fontSize: 30),
                    decoration: InputDecoration(
                      labelText: 'Product name',
                    ),
                    style: TextStyle(fontWeight: FontWeight.w600),
                    validator: (value) {
                      return value.isEmpty ? 'Product name is recquired' : null;
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextFormField(
                    controller: _priceController,
                    strutStyle: StrutStyle(fontSize: 30),
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      prefixText: '₵',
                      alignLabelWithHint: true,
                      suffixIcon: Icon(Icons.money),
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'Price is recquired' : null;
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: TextFormField(
                  controller: _shortInfoController,
                  strutStyle: StrutStyle(fontSize: 30),
                  decoration: InputDecoration(
                    labelText: 'Short info',
                  )),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: TextFormField(
                controller: _descriptionController,
                strutStyle: StrutStyle(fontSize: 30),
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 2,
                minLines: 1,
                validator: (value) {
                  return value.isEmpty ? 'Description is recquired' : null;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        )
      ]),
    );
  }

  clearFormInfo() {
    setState(() {
      _imageFile = null;
      _descriptionController.clear();
      _shortInfoController.clear();
      _priceController.clear();
      _titleController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    final String imageUrl = await uploadItemImage(_imageFile);

    uploadItemImage(_imageFile);
    saveItemInfo(imageUrl);
  }

  Future<String> uploadItemImage(fileImage) async {
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlert(
            message: 'Uploading please wait...',
          );
        });
    final Reference reference = FirebaseStorage.instance.ref().child('items');
    UploadTask storageUploadTask =
        reference.child('product_$productId.jpg').putFile(fileImage);
    TaskSnapshot taskSnapshot = await storageUploadTask;
    String downloadurl = await taskSnapshot.ref.getDownloadURL();
    Navigator.of(context).pop();
    return downloadurl;
  }

  saveItemInfo(downloadUrl) async {
    // final itemsRef = FirebaseFirestore.instance.collection('items');
    FirebaseFirestore.instance.collection('items').doc(productId).set({
      'shortInfo': _shortInfoController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': int.parse(_priceController.text),
      'publishedDate': DateTime.now(),
      'status': 'availabbe',
      'title': _titleController.text.trim(),
      'thumbnailUrl': downloadUrl,
      'docId': productId
    });

    setState(() {
      _imageFile = null;
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionController.clear();
      _shortInfoController.clear();
      _priceController.clear();
      _titleController.clear();
    });
  }
}
