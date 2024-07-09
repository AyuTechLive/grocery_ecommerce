import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/Orders/cancelledorder.dart';
import 'package:hakikat_app_new/AdminSide/Orders/placedorders.dart';
import 'package:hakikat_app_new/AdminSide/addbanner.dart';
import 'package:hakikat_app_new/AdminSide/addcategory.dart';
import 'package:hakikat_app_new/AdminSide/addevents.dart';
import 'package:hakikat_app_new/AdminSide/addproduct.dart';
import 'package:hakikat_app_new/AdminSide/removebanner.dart';
import 'package:hakikat_app_new/AdminSide/testing.dart';
import 'package:hakikat_app_new/AdminSide/testing2.dart';
import 'package:hakikat_app_new/AdminSide/users/addmoney.dart';
import 'package:hakikat_app_new/ItemsShowing/outofstockitems.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.01),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade50, Colors.white],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.04, right: width * 0.04, top: height * 0.01),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAdminButton(
                  context,
                  'Add Product',
                  Icons.add_box,
                  AddProduct(),
                ),
                // _buildAdminButton(
                //   context,
                //   'See Products',
                //   Icons.list,
                //   ProductListScreen(),
                // ),
                _buildAdminButton(
                  context,
                  'Add Category',
                  Icons.category,
                  AddCategory(),
                ),
                // _buildAdminButton(
                //   context,
                //   'Category List',
                //   Icons.list_alt,
                //   CategoryListScreen(),
                // ),
                _buildAdminButton(
                  context,
                  'Add Banner',
                  Icons.image,
                  AddBanner(),
                ),
                _buildAdminButton(
                  context,
                  'Add Event',
                  Icons.event,
                  AddEvent(),
                ),
                _buildAdminButton(
                  context,
                  'Orders',
                  Icons.shopping_cart,
                  AdminOrderHistoryScreen(),
                ),
                _buildAdminButton(
                  context,
                  'Cancelled Orders',
                  Icons.cancel,
                  CancelledOrdersScreen(),
                ),
                _buildAdminButton(
                  context,
                  'Add Money',
                  Icons.attach_money,
                  AddMoney(),
                ),
                _buildAdminButton(
                  context,
                  'Banners',
                  Icons.branding_watermark,
                  AllBanners(),
                ),
                _buildAdminButton(
                  context,
                  'Out OF Stock',
                  Icons.remove_shopping_cart,
                  OutOfStockItems(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton(
      BuildContext context, String title, IconData icon, Widget destination) {
    return ElevatedButton(
      onPressed: () => nextScreen(context, destination),
      style: ElevatedButton.styleFrom(
        // primary: Colors.white,
        // onPrimary: Colors.green,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
