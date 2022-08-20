import 'package:e_shop/widgets/cartList.dart';
import 'package:flutter/material.dart';
import '../counters/cartitemcounter.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final PreferredSizeWidget bottom;
  // MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
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
            // fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Blackchancery'),
      ),
      // bottom: bottom,
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
                          newcontext.watch<CartItemCounter>().count.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
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
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
