import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/ContactUs/helpscreen.dart';
import 'package:hakeekat_farmer_version/ContactUs/paymentqr.dart';
import 'package:hakeekat_farmer_version/Events/events_page.dart';
import 'package:hakeekat_farmer_version/Gallery/galleryalbum.dart';
import 'package:hakeekat_farmer_version/Membership/farmer_membership_form.dart';
import 'package:hakeekat_farmer_version/Membership/farmerapplicationlist.dart';
import 'package:hakeekat_farmer_version/Membership/sanstha_membership_form.dart';
import 'package:hakeekat_farmer_version/Tutorials/pdflist.dart';
import 'package:hakeekat_farmer_version/Tutorials/videoslist.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu, color: Colors.black),
        title: Text('Hakeekat Farmer',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        actions: [
          Icon(Icons.notifications, color: Colors.orange),
          SizedBox(width: 10),
          Icon(Icons.account_circle, color: Colors.grey),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search any categories',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.cyan[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildCategoryCard(
                  'Videos',
                  Icons.pest_control,
                  () {
                    nextScreen(context, VideosListScreen());
                  },
                ),
                _buildCategoryCard(
                  'Pdf File',
                  Icons.grass,
                  () {
                    nextScreen(context, PdfListScreen());
                  },
                ),
                _buildCategoryCard(
                  'Sanstha Membership',
                  Icons.local_florist,
                  () {
                    nextScreen(context, MembershipForm());
                  },
                ),
                _buildCategoryCard(
                  'Farmer Membership',
                  Icons.water_drop,
                  () {
                    nextScreen(context, FarmerMembershipForm());
                  },
                ),
                _buildCategoryCard(
                  'Gallery',
                  Icons.home,
                  () {
                    nextScreen(context, GalleryAlbum());
                  },
                ),
                _buildCategoryCard(
                  'Events',
                  Icons.favorite,
                  () {
                    nextScreen(context, EventPage());
                  },
                ),
                _buildCategoryCard(
                  'QR',
                  Icons.agriculture,
                  () {
                    nextScreen(context, QrCode());
                  },
                ),
                _buildCategoryCard(
                  'Contact Us',
                  Icons.build,
                  () {
                    nextScreen(context, HelpScreen());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Card(
        color: AppColors.greenthemecolor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
