import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/config/config.dart';
import 'package:e_shop/counters/cartitemcounter.dart';
import 'package:e_shop/models/items.dart';
import 'package:e_shop/store/product_page.dart';
import 'package:e_shop/widgets/cartList.dart';
import 'package:e_shop/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../widgets/searchBox.dart';

class StoreHome extends StatefulWidget {
  static const routeName = '/store-home';
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            title: Text('E-Shop'),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        return CartList();
                      }),
                  Positioned(
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20,
                          color: Colors.amber,
                        ),
                        Positioned(
                          child: Consumer<CartItemCounter>(
                            builder: (BuildContext newcontext, counter, _) {
                              return Text(
                                newcontext
                                    .watch<CartItemCounter>()
                                    .count
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              );
                            },
                          ),
                          top: 3.0,
                          bottom: 4.0,
                          right: 5,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          drawer: MyDrawer(),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: true, delegate: SearchBoxDelegate()),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    .limit(15)
                    .orderBy('publishedDate', descending: true)
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          itemCount: dataSnapshot.data.docs.length,
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                dataSnapshot.data.docs[index].data());
                            return sourceInfo(model, context);
                          },
                        );
                },
              )
            ],
          )),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
          builder: (_) => ProductPage(
                itemModel: model,
              ));
      Navigator.push(context, route);
    },
    splashColor: Colors.amber,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Card(
        child: Container(
          height: 190,
          width: double.infinity,
          child: Row(
            children: [
              Image.network(
                model.thumbnailUrl,
                width: 200,
                height: 160,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                  child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            softWrap: true,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(shape: BoxShape.rectangle),
                        alignment: Alignment.topLeft,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50%',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Text(
                                'Off%',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  'Original Price: ₵',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  (model.price + model.price).toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  'New Price: ₵',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.purple,
                                  ),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.purple,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              checkIteminCart(model.shortInfo, context);
                            })
                        : IconButton(
                            icon: Icon(Icons.delete), onPressed: () {}),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.purpleAccent, String imgPath}) {
  return Container();
}

void checkIteminCart(String docId, BuildContext context) {
  ShopApp.sharedPreferences.getStringList(ShopApp.userCartList).contains(docId)
      ? Fluttertoast.showToast(msg: 'Item is already in cart')
      : addItemToCart(docId, context);
}

addItemToCart(String docId, BuildContext context) {
  List tempCartList =
      ShopApp.sharedPreferences.getStringList(ShopApp.userCartList);
  tempCartList.add(docId);

  FirebaseFirestore.instance
      .collection('user')
      .doc(ShopApp.sharedPreferences.getString(ShopApp.userUID))
      .update({ShopApp.userCartList: tempCartList}).then((value) {
    Fluttertoast.showToast(msg: 'Item added to cart succesfully');
    ShopApp.sharedPreferences.setStringList(ShopApp.userCartList, tempCartList);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });

  // FirebaseFirestore.instance
  //     .collection('user')
  //     .doc(ShopApp.sharedPreferences.getString(ShopApp.userUID))
  //     .update({ShopApp.userCartList: cart});
}
