import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/appimg.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class CategoryProduct extends StatefulWidget {
  final String? categoryname;
  const CategoryProduct({super.key, this.categoryname});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  final databaseRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryname ?? 'All Products'),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  controller: searchController,
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
                  onChanged: (value) {
                    filterProducts(value);
                  },
                ),
              ),
            ),
          ]),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(width * 0.06),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.75,
                crossAxisSpacing: width * 0.03,
                mainAxisSpacing: height * 0.01,
                crossAxisCount: 2,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> product = filteredProducts[index];
                return Items(
                  ontap: () {
                    nextScreen(
                        context,
                        ProductDetails(
                          imageUrls: List<String>.from(product['Product Img'] ??
                              [AppImage.defaultimgurl]),
                          orderid: product['id'],
                          img: (product['Product Img'] != null &&
                                  product['Product Img'].isNotEmpty)
                              ? product['Product Img'][0]
                              : AppImage.defaultimgurl,
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
                          imageUrls: List<String>.from(product['Product Img'] ??
                              [AppImage.defaultimgurl]),
                          orderid: product['id'],
                          img: (product['Product Img'] != null &&
                                  product['Product Img'].isNotEmpty)
                              ? product['Product Img'][0]
                              : AppImage.defaultimgurl,
                          maxquantity: int.parse(product['Product Stock']),
                          price: product['Product Price'],
                          title: product['Product Title'] ?? '',
                          subtitle: product['Product Subtitle'] ?? '',
                        ));
                  },
                  img: (product['Product Img'] != null &&
                          product['Product Img'].isNotEmpty)
                      ? product['Product Img'][0]
                      : AppImage.defaultimgurl,
                  price: product['Product Price'],
                  title: product['Product Title'] ?? '',
                  subtitle: product['Product Subtitle'] ?? '',
                );
              },
            ),
          ),
        ],
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
              'Product Stock': value['Product Stock'],
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Img': value['Product Img'],
              'Product Price': value['Product Price'],
              'id': value['id'],
            };

            if (widget.categoryname == 'All Products' ||
                (value.containsKey('Category') &&
                    value['Category'] == widget.categoryname)) {
              if (mounted) {
                setState(() {
                  products.add(product);
                  filteredProducts.add(product);
                });
              }
            }
          }
        });
      }
    });
  }
}
