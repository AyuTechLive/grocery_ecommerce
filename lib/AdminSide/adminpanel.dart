import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/Orders/placedorders.dart';
import 'package:hakikat_app_new/AdminSide/addbanner.dart';
import 'package:hakikat_app_new/AdminSide/addcategory.dart';
import 'package:hakikat_app_new/AdminSide/addproduct.dart';
import 'package:hakikat_app_new/AdminSide/testing.dart';
import 'package:hakikat_app_new/AdminSide/testing2.dart';
import 'package:hakikat_app_new/AdminSide/users/addmoney.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsetsDirectional.only(end: 20, start: 20),
        child: Column(
          children: [
            RoundButton(
              title: 'Add Product',
              onTap: () {
                nextScreen(context, AddProduct());
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'See Product Product',
              onTap: () {
                nextScreen(context, ProductListScreen());
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Add Category',
              onTap: () {
                nextScreen(context, AddCategory());
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Category List screen',
              onTap: () {
                nextScreen(context, CategoryListScreen());
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Add Banner',
              onTap: () {
                nextScreen(context, AddBanner());
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Orders',
              onTap: () {
                nextScreen(context, AdminOrderHistoryScreen());
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Add Money',
              onTap: () {
                nextScreen(context, AddMoney());
              },
            )
          ],
        ),
      ),
    );
  }
}
