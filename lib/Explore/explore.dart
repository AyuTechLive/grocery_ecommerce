import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/AdminSide/editcategory.dart';
import 'package:hakikat_app_new/AdminSide/editproduct.dart';
import 'package:hakikat_app_new/Explore/components/categorycard.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ItemsShowing/CategoryProducts.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/defaultimage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

List<Color> colors = [Color(0xFF181725), Color(0x19F8A44C)];

class _ExploreState extends State<Explore> {
  final databaseRef = FirebaseDatabase.instance.ref();
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('Categories');
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
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
              'Product Price': value['Product Price'],
              'Product Stock': value['Product Stock'],
              'id': value['id'],
              'Product Discription': value['Product Discription'],
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

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => (product['Product Title'] ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
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
            Text(
              'Find Products',
              style: TextStyle(
                color: Color(0xFF181725),
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w400,
                height: 0.04,
              ),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Expanded(
            child: searchController.text.isEmpty
                ? StreamBuilder<QuerySnapshot>(
                    stream: _categoriesCollection.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return GridView.builder(
                        padding: EdgeInsets.all(width * 0.06),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing:
                              width * 0.03, // Space between items horizontally
                          mainAxisSpacing: height * 0.019,
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return CategoryCard(
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCategoryScreen(
                                    categoryId: data[
                                        'Category Name'], // Replace with the actual category ID
                                    initialCategoryName: data[
                                        'Category Name'], // Replace with the initial category name
                                    initialCategoryImageUrl: data[
                                        'Category Img'], // Replace with the initial image URL
                                  ),
                                ),
                              );
                              // nextScreen(
                              //     context,
                              //     CategoryProduct(
                              //       categoryname: data['Category Name'],
                              //     ));
                            },
                            color: Color(0x19F8A44C),
                            img: data['Category Img'] ?? AppImage.defaultimgurl,
                            title: data['Category Name'] ?? '',
                          );
                        },
                      );

                      // ListView(
                      //   children: snapshot.data!.docs
                      //       .map((DocumentSnapshot document) {
                      //     Map<String, dynamic> data =
                      //         document.data() as Map<String, dynamic>;
                      //     return ListTile(
                      //       title: Text(data['GameName'] ?? ''),
                      //       subtitle: Text(data['GameImg'] ?? ''),
                      //     );
                      //   }).toList(),
                      // );
                    },
                  )
                //  GridView.builder(
                //     padding: EdgeInsets.all(width * 0.06),
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisSpacing:
                //           width * 0.03, // Space between items horizontally
                //       mainAxisSpacing: height * 0.019,
                //       crossAxisCount: 2,
                //     ),
                //     itemCount: 5,
                //     itemBuilder: (context, index) {
                //       return CategoryCard(
                //         ontap: () {
                //           nextScreen(context, CategoryProduct());
                //         },
                //         color: Color(0x19F8A44C),
                //         img: '',
                //         title: '',
                //       );
                //     },
                //   )
                : GridView.builder(
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
                                discription:
                                    product['Product Discription'] ?? '',
                                imageUrls: List<String>.from(
                                    product['Product Img'] ??
                                        [AppImage.defaultimgurl]),
                                orderid: product['id'],
                                img: (product['Product Img'] != null &&
                                        product['Product Img'].isNotEmpty)
                                    ? product['Product Img'][0]
                                    : AppImage.defaultimgurl,
                                maxquantity:
                                    int.parse(product['Product Stock']),
                                price: product['Product Price'],
                                title: product['Product Title'] ?? '',
                                subtitle: product['Product Subtitle'] ?? '',
                              ));
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
                        price: product['Product Price'] ?? '',
                        title: product['Product Title'] ?? '',
                        subtitle: product['Product Subtitle'] ?? '',
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
