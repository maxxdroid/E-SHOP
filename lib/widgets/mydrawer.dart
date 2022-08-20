import 'dart:ffi';

import 'package:e_shop/address/address.dart';
import 'package:e_shop/authentication/authentication.dart';
import 'package:e_shop/config/config.dart';
import 'package:e_shop/orders/my_orders.dart';
import 'package:e_shop/store/cart.dart';
import 'package:e_shop/store/search.dart';
import 'package:flutter/material.dart';
import '../store/storehome.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // Future _function() async {
  //   var url  = await ShopApp.sharedPreferences.getString(ShopApp.userAvatarUrl);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _function();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.grey, Colors.amber],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(80),
                  elevation: 8,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      // child: Image.network(
                      //   ShopApp.sharedPreferences
                      //       .getString(ShopApp.userAvatarUrl),
                      //   fit: BoxFit.cover,
                      //   loadingBuilder: (BuildContext context, Widget child,
                      //       ImageChunkEvent loadingProgress) {
                      //     if (loadingProgress == null) return child;
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         value: loadingProgress.expectedTotalBytes != null
                      //             ? loadingProgress.cumulativeBytesLoaded /
                      //                 loadingProgress.expectedTotalBytes
                      //             : null,
                      //       ),
                      //     );
                      //   },
                      // ),

                      // child: CachedNetworkImage(
                      // imageUrl: ShopApp.sharedPreferences
                      //     .getString(ShopApp.userAvatarUrl) ,
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      //   placeholder: (context, url) =>
                      //       CircularProgressIndicator(),
                      // ) ,
                      //                   backgroundImage: CachedNetworkImage(
                      //    imageUrl:ShopApp.sharedPreferences.getString(ShopApp.userAvatarUrl,
                      //    placeholder: (context,url) => CircularProgressIndicator(),
                      //    errorWidget: (context,url,error) => new Icon(Icons.error),
                      //  ),
                      backgroundImage: (ShopApp.sharedPreferences
                                  .getString(ShopApp.userAvatarUrl) ==
                              null)
                          ? AssetImage(
                              'assets/images/account.png',
                            )
                          : NetworkImage(ShopApp.sharedPreferences
                              .getString(ShopApp.userAvatarUrl)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ShopApp.sharedPreferences.getString(ShopApp.userName),
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         colors: [Colors.grey, Colors.amber],
            //         begin: const FractionalOffset(0.0, 0.0),
            //         end: const FractionalOffset(0.0, 0.0),
            //         stops: [0.0, 1.0],
            //         tileMode: TileMode.clamp)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: Text('Home'),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (_) => StoreHome());
                    Navigator.pushReplacement(context, route);
                    print(ShopApp.sharedPreferences
                        .getString(ShopApp.userAvatarUrl));
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: Colors.black,
                  ),
                  title: Text('My Orders'),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.push(context, route);
                    ;
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  title: Text('My Cart'),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: Text('Search'),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.black,
                  ),
                  title: Text('Add new Address'),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (c) => AuthenticationScreen());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text('Log out'),
                  onTap: () {
                    ShopApp.auth.signOut().then((c) {
                      Route route = MaterialPageRoute(
                          builder: (c) => AuthenticationScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
