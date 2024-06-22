import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Account/addressscreen.dart';
import 'package:hakikat_app_new/Explore/explore.dart';
import 'package:hakikat_app_new/Home/Components/homecategroyitem.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/Home/Components/sectionheader.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/ItemsShowing/CategoryProducts.dart';
import 'package:hakikat_app_new/ItemsShowing/Exclusiveitemshowing.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/appimg.dart';
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
                      child: Icon(Icons.search),
                    ),
                    hintText: 'Search Store',
                    iconColor: Color(0xFF4C4E4D),
                    border: InputBorder.none,
                  ),
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
            Sectionheader(
              title: 'Exclusive Offer',
              ontap: () {
                nextScreen(context, ExclusiveItems(categoryname: 'Exclusive'));
              },
            ),
            buildProductList(filteredProducts, 5),
            SizedBox(height: height * 0.02),
            Sectionheader(
              title: 'Categories',
              ontap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return MainPage(index: 1);
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
                  return CircularProgressIndicator();
                }
                final documents = snapshot.data!.docs;
                return SizedBox(
                  height: height * 0.117,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    separatorBuilder: (context, index) {
                      return SizedBox(width: width * 0.05);
                    },
                    itemCount: documents.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      final data = document.data() as Map?;
                      if (data == null) {
                        return SizedBox();
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
            SizedBox(height: height * 0.02),
            Sectionheader(
              title: 'Best Selling',
              ontap: () {
                nextScreen(
                    context, ExclusiveItems(categoryname: 'BestSelling'));
              },
            ),
            buildProductList(
                products
                    .where((product) => product['BestSelling'] == true)
                    .toList(),
                5),
            SizedBox(height: height * 0.02),
            Sectionheader(
              title: 'All Products',
              ontap: () {
                nextScreen(
                    context, CategoryProduct(categoryname: 'All Products'));
              },
            ),
            buildProductList(products, 5),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget buildProductList(
      List<Map<String, dynamic>> productList, int maxItems) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height * 0.3, // Set a fixed height or adjust as needed
          child: ListView.separated(
            padding:
                EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
            separatorBuilder: (context, index) {
              return SizedBox(width: constraints.maxWidth * 0.05);
            },
            itemCount:
                productList.length > maxItems ? maxItems : productList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Map<String, dynamic> product = productList[index];
              return Container(
                width: constraints.maxWidth * 0.4, // Adjust the width as needed
                child: Items(
                  ontap: () => navigateToProductDetails(context, product),
                  onadd: () => navigateToProductDetails(context, product),
                  img: (product['Product Img'] != null &&
                          product['Product Img'].isNotEmpty)
                      ? product['Product Img'][0]
                      : AppImage.defaultimgurl,
                  price: product['Product Price'],
                  title: product['Product Title'] ?? '',
                  subtitle: product['Product Subtitle'] ?? '',
                ),
              );
            },
          ),
        );
      },
    );
  }

  void navigateToProductDetails(
      BuildContext context, Map<String, dynamic> product) {
    nextScreen(
      context,
      ProductDetails(
        discription: product['Product Discription'] ?? '',
        imageUrls: List<String>.from(
            product['Product Img'] ?? [AppImage.defaultimgurl]),
        orderid: product['id'],
        img: (product['Product Img'] != null &&
                product['Product Img'].isNotEmpty)
            ? product['Product Img'][0]
            : AppImage.defaultimgurl,
        maxquantity: product['Product Stock'] != null
            ? int.tryParse(product['Product Stock'].toString()) ?? 0
            : 0,
        price: product['Product Price'],
        title: product['Product Title'] ?? '',
        subtitle: product['Product Subtitle'] ?? '',
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
        products.clear();
        filteredProducts.clear();

        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> product = {
              'id': value['id'],
              'Product Stock': value['Product Stock'],
              'Product Price': value['Product Price'],
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Discription': value['Product Discription'],
              'Product Img': value['Product Img'],
              'Exclusive':
                  value.containsKey('Exclusive') && value['Exclusive'] == true,
              'BestSelling': value.containsKey('BestSelling') &&
                  value['BestSelling'] == true,
            };
            if (mounted) {
              setState(() {
                products.add(product);
                if (product['Exclusive'] == true) {
                  filteredProducts.add(product);
                }
              });
            }
          }
        });
      }
    });
  }
}
