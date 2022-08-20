import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/config/config.dart';
import 'package:flutter/material.dart';

class CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: StreamBuilder<QueryDocumentSnapshot>(
        builder: (context, datasnapshot) {
          return !datasnapshot.hasData
              ? SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        datasnapshot.data.data().entries.toList().toString()),
                  );
                });
        },
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(ShopApp.sharedPreferences.getString(ShopApp.userUID))
            .snapshots(),
      ),
    ));
  }
}
