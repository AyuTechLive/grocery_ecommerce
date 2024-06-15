import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class ExclusiveItems extends StatefulWidget {
  final String categoryname;
  const ExclusiveItems({super.key, required this.categoryname});

  @override
  State<ExclusiveItems> createState() => _ExclusiveItemsState();
}

class _ExclusiveItemsState extends State<ExclusiveItems> {
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
        title: Text(widget.categoryname),
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
              physics: NeverScrollableScrollPhysics(),
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
                          orderid: product['id'],
                          img: product['Product Img'],
                          maxquantity: int.parse(product['Product Stock']),
                          price: product['Product Price'],
                          title: product['Product Title'] ?? '',
                          subtitle: product['Product Subtitle'] ?? '',
                        ));
                    // print(product['Product Img']);
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
          if (value is Map &&
              value.containsKey(widget.categoryname) &&
              value[widget.categoryname] == true) {
            Map<String, dynamic> product = {
              'Product Stock': value['Product Stock'],
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Img': value['Product Img'],
              'Product Price': value['Product Price'],
              'id': value['id'],
            };
            setState(() {
              products.add(product);
              filteredProducts
                  .add(product); // Add the product to filteredProducts as well
            });
          }
        });
      }
    });
  }
}
