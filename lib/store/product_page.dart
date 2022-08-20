import 'package:e_shop/models/items.dart';
import 'package:e_shop/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../store/storehome.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({
    this.itemModel,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.network(widget.itemModel.thumbnailUrl),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: SizedBox(
                        height: 1,
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemModel.title,
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(widget.itemModel.description),
                        Text(
                          "₵ " + widget.itemModel.price.toString(),
                          style: signTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () =>
                        checkIteminCart(widget.itemModel.docId, context),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.grey, Colors.amber],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(0.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp)),
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                        child: Text('Add To Cart'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
const signTextStyle = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 20, color: Colors.purple);
