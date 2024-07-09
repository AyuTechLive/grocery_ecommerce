import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/editproduct.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/Home/Components/outofstockitemscard.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/defaultimage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class OutOfStockItems extends StatefulWidget {
  const OutOfStockItems({super.key});

  @override
  State<OutOfStockItems> createState() => _OutOfStockItemsState();
}

class _OutOfStockItemsState extends State<OutOfStockItems> {
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
        title: Text('Out Of Stock Items'),
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
                          child: Icon(Icons.search)),
                      hintText: 'Search Store',
                      iconColor: Color(0xFF4C4E4D),
                      border: InputBorder.none),
                  onChanged: (value) {
                    filterProducts(value);
                  },
                ),
              ),
            ),
          ]),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: searchController,
          //     decoration: InputDecoration(
          //       hintText: 'Search products...',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //     onChanged: (value) {
          //       filterProducts(value);
          //     },
          //   ),
          // ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(width * 0.06),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.70,
                crossAxisSpacing: width * 0.03,
                mainAxisSpacing: height * 0.01,
                crossAxisCount: 2,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> product = filteredProducts[index];
                return OutofStockItemCard(
                  ontap: () {
                    nextScreen(
                        context,
                        ProductDetails(
                          discription: product['Product Discription'] ?? '',
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
                    // print(product['Product Img']);
                  },
                  onadd: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(
                          imageUrls: List<String>.from(
                            (product['Product Img'] ?? []).where(
                              (url) => url != AppImage.defaultimgurl,
                            ),
                          ),
                          productId: product['id'],
                          initialProductData: product,
                        ),
                      ),
                    );
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
            // Parse the Product Stock as an integer
            int productStock = int.tryParse(value['Product Stock'] ?? '') ?? 0;

            // Check if Product Stock is less than or equal to 0
            if (productStock <= 0) {
              Map<String, dynamic> product = {
                'Product Stock': value['Product Stock'],
                'Product Title': value['Product Title'],
                'Product Subtitle': value['Product Subtitle'],
                'Product Img': value['Product Img'],
                'Product Price': value['Product Price'],
                'Product Discription': value['Product Discription'],
                'id': value['id'],
              };
              setState(() {
                products.add(product);
                filteredProducts.add(product);
              });
            }
          }
        });
      }
    });
  }
}
