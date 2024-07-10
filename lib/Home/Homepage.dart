import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/ContactUs/helpscreen.dart';
import 'package:hakeekat_farmer_version/ContactUs/paymentqr.dart';
import 'package:hakeekat_farmer_version/Events/events_page.dart';
import 'package:hakeekat_farmer_version/Gallery/galleryalbum.dart';
import 'package:hakeekat_farmer_version/Membership/farmer_membership_form.dart';
import 'package:hakeekat_farmer_version/Membership/sanstha_membership_form.dart';
import 'package:hakeekat_farmer_version/Tutorials/pdflist.dart';
import 'package:hakeekat_farmer_version/Tutorials/videoslist.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fireStore2 =
      FirebaseFirestore.instance.collection('Banners').snapshots();
  final List<Map<String, dynamic>> _allCategories = [
    {
      'title': 'Videos',
      'icon': Icons.video_library,
      'screen': VideosListScreen()
    },
    {
      'title': 'PDF Files',
      'icon': Icons.picture_as_pdf,
      'screen': PdfListScreen()
    },
    {
      'title': 'Sanstha Membership',
      'icon': Icons.group,
      'screen': MembershipForm()
    },
    {
      'title': 'Farmer Membership',
      'icon': Icons.person,
      'screen': FarmerMembershipForm()
    },
    {'title': 'Gallery', 'icon': Icons.photo_library, 'screen': GalleryAlbum()},
    {'title': 'Events', 'icon': Icons.event, 'screen': EventPage()},
    {'title': 'QR Code', 'icon': Icons.qr_code, 'screen': QrCode()},
    {
      'title': 'Contact Us',
      'icon': Icons.contact_support,
      'screen': HelpScreen()
    },
  ];
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  List<Map<String, dynamic>> _foundCategories = [];

  @override
  initState() {
    _foundCategories = _allCategories;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCategories;
    } else {
      results = _allCategories
          .where((category) => category['title']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundCategories = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Add drawer functionality here
          },
        ),
        title: Text('Hakeekat Farmer',
            style: TextStyle(
                color: AppColors.greenthemecolor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.orange),
            onPressed: () {
              // Add notifications functionality here
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.grey),
            onPressed: () {
              // Add profile functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  hintText: 'Search any categories',
                  prefixIcon:
                      Icon(Icons.search, color: AppColors.greenthemecolor),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder<QuerySnapshot>(
              stream: fireStore2,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No banners found.');
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    Center(
                      child: CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.93,
                          aspectRatio: 2.2,
                          initialPage: 2,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: snapshot.data!.docs.map((document) {
                          String imageUrl = document['Banner Image Link'];
                          return Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                onTap: () {
                                  // Handle banner tap
                                },
                                child: Container(
                                  height: 10,
                                  width: 500,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: height * 0.02),
            _foundCategories.length > 0
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _foundCategories.length,
                    itemBuilder: (context, index) => _buildCategoryCard(
                      _foundCategories[index]['title'],
                      _foundCategories[index]['icon'],
                      () => nextScreen(
                          context, _foundCategories[index]['screen']),
                    ),
                  )
                : Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.greenthemecolor,
                AppColors.greenthemecolor.withOpacity(0.7)
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
