import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/addcategory.dart';
import 'package:hakikat_app_new/AdminSide/addproduct.dart';
import 'package:hakikat_app_new/AdminSide/testing.dart';
import 'package:hakikat_app_new/AdminSide/testing2.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          RoundButton(
            title: 'Add Product',
            onTap: () {
              nextScreen(context, AddProduct());
            },
          ),
          RoundButton(
            title: 'See Product Product',
            onTap: () {
              nextScreen(context, ProductListScreen());
            },
          ),
          RoundButton(
            title: 'Add games',
            onTap: () {
              nextScreen(context, AddGames());
            },
          ),
          RoundButton(
            title: 'Category List screen',
            onTap: () {
              nextScreen(context, CategoryListScreen());
            },
          )
        ],
      ),
    );
  }
}
