import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/Account/addadress.dart';
import 'package:hakikat_app_new/Account/addressscreen.dart';
import 'package:hakikat_app_new/Explore/components/categorycard.dart';
import 'package:hakikat_app_new/Explore/explore.dart';
import 'package:hakikat_app_new/Home/Components/homecategroyitem.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/Home/Components/sectionheader.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/ItemsShowing/CategoryProducts.dart';
import 'package:hakikat_app_new/ItemsShowing/Exclusiveitemshowing.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final searchController = TextEditingController();
  final searchcontroller = TextEditingController();
  final fireStore2 =
      FirebaseFirestore.instance.collection('Banners').snapshots();
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('Categories');
  String? _selectedAddress;

  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> _navigateToAddressScreen(BuildContext context) async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(
          onAddressSelected: (address) {
            setState(() {
              _selectedAddress = address;
            });
          },
        ),
      ),
    );

    if (selectedAddress != null) {
      setState(() {
        _selectedAddress = selectedAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_pin),
                IconButton(
                  onPressed: () {
                    _navigateToAddressScreen(context);
                  },
                  icon: SizedBox(
                    width: width * 0.6,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      _selectedAddress ?? 'Select Address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4C4E4D),
                        fontSize: 18,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.879,
              height: height * 0.057,
              decoration: ShapeDecoration(
                color: Color(0xFFF1F2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Center(
                child: TextFormField(
                  textAlign: TextAlign.justify,
                  controller: searchcontroller,
                  cursorColor: Color(0xFF4C4E4D),
                  decoration: InputDecoration(
                      icon: Padding(
                          padding: EdgeInsets.only(left: width * 0.03),
                          child: Icon(Icons.search)),
                      hintText: 'Search Store',
                      iconColor: Color(0xFF4C4E4D),
                      border: InputBorder.none),
                  onTap: () {
                    nextScreen(context, Explore());
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(height: height * 0.022),
            StreamBuilder<QuerySnapshot>(
              stream: fireStore2, // Use the stream variable
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

                // Rest of the CarouselSlider code...

                // Now, integrate the _buildCarouselDots method
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
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
                          // Map the snapshot documents to carousel items
                          String imageUrl = document['Course Img Link'];
                          // Assuming this is how your data is structured
                          // Build your carousel item with the image URL
                          String bannerfunction = document['Banner Function'];
                          String bannertype = document['Banner Type'];
                          return Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                onTap: () {
                                  // if (bannertype == 'External Link') {
                                  //   _launchURL(bannerfunction);
                                  // } else if (bannertype ==
                                  //     'Course Function') {
                                  //   fetchData(bannerfunction);
                                  // } else if (bannertype == 'Nothing') {}
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
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(), // Make sure to convert the map result to a list

                        // Existing CarouselSlider code...
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   // Call the modified _buildCarouselDots with the length of the snapshot documents
                    //   children:
                    //       _buildCarouselDots(snapshot.data!.docs.length),
                    // ),
                  ],
                );
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Sectionheader(
              title: 'Exclusive Offer',
              ontap: () {
                nextScreen(context, ExclusiveItems(categoryname: 'Exclusive'));
              },
            ),
            SizedBox(
              height: height * 0.277,
              child: ListView.separated(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                separatorBuilder: (context, index) {
                  return SizedBox(width: width * 0.05);
                },
                itemCount:
                    filteredProducts.length > 5 ? 5 : filteredProducts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Map<String, dynamic> product = filteredProducts[index];
                  return Items(
                    ontap: () {
                      nextScreen(
                          context,
                          ProductDetails(
                            orderid: product['id'],
                            img: product['Product Img'],
                            maxquantity: int.parse(product['Product Stock']),
                            price: product['Product Price'],
                            title: product['Product Title'] ?? '',
                            subtitle: product['Product Subtitle'] ?? '',
                          ));
                    },
                    onadd: () {
                      nextScreen(
                          context,
                          ProductDetails(
                            orderid: product['id'],
                            img: product['Product Img'],
                            maxquantity: int.parse(product['Product Stock']),
                            price: product['Product Price'],
                            title: product['Product Title'] ?? '',
                            subtitle: product['Product Subtitle'] ?? '',
                          ));
                    },
                    img: product['Product Img'],
                    price: product['Product Price'],
                    title: product['Product Title'] ?? '',
                    subtitle: product['Product Subtitle'] ?? '',
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Sectionheader(
              title: 'Categories',
              ontap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return MainPage(
                      index: 1,
                    );
                  },
                ));
              },
            ),
            StreamBuilder(
              stream: _categoriesCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator(); // or show a loading indicator
                }

                final documents = snapshot.data!.docs;

                return SizedBox(
                  height: height * 0.117,
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                    ),
                    separatorBuilder: (context, index) {
                      return SizedBox(width: width * 0.05);
                    },
                    itemCount: documents.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      final data = document.data() as Map?;

                      if (data == null) {
                        return SizedBox(); // or show a placeholder widget
                      }

                      return HomeCategoryItems(
                        img: data['Category Img'] ?? '',
                        title: data['Category Name'] ?? '',
                        ontap: () {
                          nextScreen(
                            context,
                            CategoryProduct(
                              categoryname: data['Category Name'] ?? '',
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            // SizedBox(
            //   height: height * 0.117,
            //   child: ListView.separated(
            //     padding:
            //         EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            //     separatorBuilder: (context, index) {
            //       return SizedBox(width: width * 0.05);
            //     },
            //     itemCount: 5,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       return HomeCategoryItems(
            //         img:
            //             'https://firebasestorage.googleapis.com/v0/b/carvizo-ce898.appspot.com/o/4215936-pulses-png-8-png-image-pulses-png-409_409%201.png?alt=media&token=455a1ee0-ce82-41f6-91f2-3d71789408f7',
            //         title: 'Pulses',
            //         ontap: () {},
            //       );
            //     },
            //   ),
            // ),
            SizedBox(
              height: height * 0.02,
            ),
            Sectionheader(
              title: 'Best Selling',
              ontap: () {
                nextScreen(
                    context, ExclusiveItems(categoryname: 'BestSelling'));
              },
            ),
            SizedBox(
              height: height * 0.277,
              child: ListView.separated(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                separatorBuilder: (context, index) {
                  return SizedBox(width: width * 0.05);
                },
                itemCount: products
                            .where((product) => product['BestSelling'] == true)
                            .length >
                        5
                    ? 5
                    : products
                        .where((product) => product['BestSelling'] == true)
                        .length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Map<String, dynamic> product = products
                      .where((product) => product['BestSelling'] == true)
                      .toList()[index];
                  return Items(
                    price: product['Product Price'],
                    img: product['Product Img'],
                    onadd: () {
                      nextScreen(
                          context,
                          ProductDetails(
                            orderid: product['id'],
                            img: product['Product Img'],
                            maxquantity: int.parse(product['Product Stock']),
                            price: product['Product Price'],
                            title: product['Product Title'] ?? '',
                            subtitle: product['Product Subtitle'] ?? '',
                          ));
                    },
                    ontap: () {
                      nextScreen(
                          context,
                          ProductDetails(
                            orderid: product['id'],
                            img: product['Product Img'],
                            maxquantity: int.parse(product['Product Stock']),
                            price: product['Product Price'],
                            title: product['Product Title'] ?? '',
                            subtitle: product['Product Subtitle'] ?? '',
                          ));
                    },
                    subtitle: product['Product Subtitle'] ?? '',
                    title: product['Product Title'] ?? '',
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Sectionheader(
              title: 'All Products',
              ontap: () {
                nextScreen(
                    context,
                    CategoryProduct(
                      categoryname: 'All Products',
                    ));
              },
            ),
            SizedBox(
              height: height * 0.277,
              child: ListView.separated(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                separatorBuilder: (context, index) {
                  return SizedBox(width: width * 0.05);
                },
                itemCount: products.length > 5 ? 5 : products.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Map<String, dynamic> product = products[index];
                  return Items(
                    price: product['Product Price'],
                    img: product['Product Img'],
                    onadd: () {
                      nextScreen(
                          context,
                          ProductDetails(
                            orderid: product['id'],
                            img: product['Product Img'],
                            maxquantity: int.parse(product['Product Stock']),
                            price: product['Product Price'],
                            title: product['Product Title'] ?? '',
                            subtitle: product['Product Subtitle'] ?? '',
                          ));
                    },
                    ontap: () {
                      nextScreen(
                          context,
                          ProductDetails(
                            orderid: product['id'],
                            img: product['Product Img'],
                            maxquantity: int.parse(product['Product Stock']),
                            price: product['Product Price'],
                            title: product['Product Title'] ?? '',
                            subtitle: product['Product Subtitle'] ?? '',
                          ));
                    },
                    subtitle: product['Product Subtitle'] ?? '',
                    title: product['Product Title'] ?? '',
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.02,
            )
          ],
        ),
      ),
    );
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => (product['Product Title'] ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void fetchProducts() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        products.clear(); // Clear the existing data
        filteredProducts.clear(); // Clear the existing filtered data

        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> product = {
              'id': value['id'],
              'Product Stock': value['Product Stock'],
              'Product Price': value['Product Price'],
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Img': value['Product Img'],
              'Exclusive':
                  value.containsKey('Exclusive') && value['Exclusive'] == true,
              'BestSelling': value.containsKey('BestSelling') &&
                  value['BestSelling'] == true,
            };
            setState(() {
              products.add(product);
              if (product['Exclusive'] == true) {
                filteredProducts.add(product);
              }
            });
          }
        });
      }
    });
  }
}
