import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Favorites/component/favoritetile.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/defaultimage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteIds = [];
  List<Map<String, dynamic>> favoriteData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteIds();
  }

  Future<void> _fetchFavoriteIds() async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (userDocSnapshot.exists) {
      List<dynamic> favorites = userDocSnapshot.get('Favorites') ?? [];
      favoriteIds = favorites.cast<String>().toList();
      await _fetchFavoriteData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchFavoriteData() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    List<Map<String, dynamic>> fetchedData = [];

    for (String favoriteId in favoriteIds) {
      DataSnapshot snapshot = await databaseReference.child(favoriteId).get();
      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        Map<String, dynamic> favoriteItem = {
          'id': data['id'],
          'Product Stock': data['Product Stock'],
          'Product Price': data['Product Price'],
          'Product Title': data['Product Title'],
          'Product Subtitle': data['Product Subtitle'],
          'Product Img': data['Product Img'],
          'Product Discription': data['Product Discription'],
        };
        fetchedData.add(favoriteItem);
      }
    }

    setState(() {
      favoriteData = fetchedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Favorites'),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteData.isEmpty
              ? Center(child: Text('No items in your favorites'))
              : Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      width: width * (0.876),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFE2E2E2),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Column(
                            children: [],
                          );
                        },
                        itemCount: favoriteData.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> item = favoriteData[index];
                          return Dismissible(
                              key: Key(item['id']),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: AppColors.greenthemecolor,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                _removeFromFavorites(item['id']);
                              },
                              child: FavoriteTile(
                                ontap: () {
                                  nextScreen(
                                      context,
                                      ProductDetails(
                                        discription:
                                            item['Product Discription'] ?? '',
                                        imageUrls: List<String>.from(
                                            item['Product Img'] ??
                                                [AppImage.defaultimgurl]),
                                        orderid: item['id'],
                                        img: (item['Product Img'] != null &&
                                                item['Product Img'].isNotEmpty)
                                            ? item['Product Img'][0]
                                            : AppImage.defaultimgurl,
                                        maxquantity:
                                            int.parse(item['Product Stock']),
                                        price: item['Product Price'],
                                        title: item['Product Title'] ?? '',
                                        subtitle:
                                            item['Product Subtitle'] ?? '',
                                      ));
                                },
                                ondelete: () {
                                  _removeFromFavorites(item['id']);
                                },
                                img: (item['Product Img'] != null &&
                                        item['Product Img'].isNotEmpty)
                                    ? item['Product Img'][0]
                                    : AppImage.defaultimgurl,
                                price: item['Product Price'],
                                title: item['Product Title'] ?? '',
                                subtitle: item['Product Subtitle'] ?? '',
                              ));
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Future<void> _removeFromFavorites(String favoriteId) async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    // Remove the favoriteId from the Favorites array field
    await userDocRef.update({
      'Favorites': FieldValue.arrayRemove([favoriteId]),
    });

    // Update the local favoriteIds list
    setState(() {
      favoriteIds.remove(favoriteId);
      favoriteData.removeWhere((item) => item['id'] == favoriteId);
    });
  }
}
