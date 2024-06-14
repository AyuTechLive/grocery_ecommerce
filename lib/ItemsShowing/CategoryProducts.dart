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
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
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
              itemCount: 5,
              itemBuilder: (context, index) {
                return Items(
                  price: '100',
                  img:
                      'https://firebasestorage.googleapis.com/v0/b/oneupnoobs-9ee91.appspot.com/o/demoitem.png?alt=media&token=182d753f-603f-4fac-a4c9-bd62c4f5f8fc',
                  onadd: () {},
                  ontap: () {
                    nextScreen(context, ProductDetails());
                  },
                  subtitle: '7pcs, Price',
                  title: 'Organic Bananas',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
