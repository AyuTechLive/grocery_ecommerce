import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmerbanner.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmerevent.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmerpdf.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addgalleryimg.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/farmer_application_List.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/sanstha_application_list.dart';
import 'package:hakikat_app_new/AdminSide/Orders/cancelledorder.dart';
import 'package:hakikat_app_new/AdminSide/Orders/placedorders.dart';
import 'package:hakikat_app_new/AdminSide/addbanner.dart';
import 'package:hakikat_app_new/AdminSide/addcategory.dart';
import 'package:hakikat_app_new/AdminSide/addevents.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmervideos.dart';
import 'package:hakikat_app_new/AdminSide/addproduct.dart';
import 'package:hakikat_app_new/AdminSide/removebanner.dart';
import 'package:hakikat_app_new/AdminSide/testing.dart';
import 'package:hakikat_app_new/AdminSide/testing2.dart';
import 'package:hakikat_app_new/AdminSide/users/addmoney.dart';
import 'package:hakikat_app_new/ItemsShowing/outofstockitems.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class FarmerAdminPanel extends StatelessWidget {
  const FarmerAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Admin Panel'),
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
                  'Add Farmer Tutorials',
                  Icons.video_collection_sharp,
                  AddLecturesAdmin(),
                ),
                _buildAdminButton(
                  context,
                  'Add Farmer Pdf',
                  Icons.file_copy,
                  Addpdf(),
                ),
                _buildAdminButton(
                  context,
                  'Farmer Applications',
                  Icons.assignment,
                  FarmerApplicationsList(),
                ),
                _buildAdminButton(
                  context,
                  'Sanstha Applications',
                  Icons.assignment_turned_in,
                  SansthaApplicationList(),
                ),
                _buildAdminButton(
                  context,
                  'Add Farmer Event',
                  Icons.event,
                  AddFarmerEvent(),
                ),
                _buildAdminButton(
                  context,
                  'Add Farmer Gallery',
                  Icons.image,
                  AddGalleryImages(),
                ),
                _buildAdminButton(
                  context,
                  'Add Farmer Banner',
                  Icons.upload,
                  AddFarmerBanner(),
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
