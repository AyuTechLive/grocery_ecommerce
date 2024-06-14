import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({super.key});

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
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                filterProducts(value);
              },
            ),
          ),
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
                    // print(product['Product Img']);
                  },
                  onadd: () {},
                  img: product['Product Img'],
                  price: '100',
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
        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> product = {
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Img': value['Product Img'],
            };
            setState(() {
              products.add(product);
              filteredProducts =
                  products; // Initialize filteredProducts with all products
            });
          }
        });
      }
    });
  }
}
