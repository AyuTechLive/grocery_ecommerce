import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/Home/Components/homecategroyitem.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> imageUrls = [
  'https://www.shutterstock.com/image-photo/fresh-healthy-food-vegetables-grocery-260nw-1175684464.jpg',
  'https://firebasestorage.googleapis.com/v0/b/carvizo-ce898.appspot.com/o/grocery-store-sale-banner-template_23-2151089846.jpg?alt=media&token=e4f725e1-6c2d-4742-b2f6-5489a46810c7'
  // Add more URLs as needed
];

class _HomePageState extends State<HomePage> {
  final searchcontroller = TextEditingController();
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_pin),
                Text(
                  'Dhaka, Banassre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4C4E4D),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0,
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
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(height: height * 0.022),
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.5,
                initialPage: 2,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: imageUrls.map((url) {
                // Map the snapshot documents to carousel items
                String imageUrl = url;
                // Assuming this is how your data is structured
                // Build your carousel item with the image URL

                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        height: 10,
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
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
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.06,
                ),
                Text(
                  'Exclusive Offer',
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF53B175),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )),
                SizedBox(
                  width: width * 0.02,
                )
              ],
            ),
            SizedBox(
              height: height * 0.277,
              child: ListView.separated(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                separatorBuilder: (context, index) {
                  return SizedBox(width: width * 0.05);
                },
                itemCount: 5,
                scrollDirection: Axis.horizontal,
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
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.06,
                ),
                Text(
                  'Categories',
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF53B175),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )),
                SizedBox(
                  width: width * 0.02,
                )
              ],
            ),
            SizedBox(
              height: height * 0.117,
              child: ListView.separated(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                separatorBuilder: (context, index) {
                  return SizedBox(width: width * 0.05);
                },
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return HomeCategoryItems(
                    img:
                        'https://firebasestorage.googleapis.com/v0/b/carvizo-ce898.appspot.com/o/4215936-pulses-png-8-png-image-pulses-png-409_409%201.png?alt=media&token=455a1ee0-ce82-41f6-91f2-3d71789408f7',
                    title: 'Pulses',
                    ontap: () {},
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.06,
                ),
                Text(
                  'Best Selling',
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF53B175),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )),
                SizedBox(
                  width: width * 0.02,
                )
              ],
            ),
            SizedBox(
              height: height * 0.277,
              child: ListView.separated(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                separatorBuilder: (context, index) {
                  return SizedBox(width: width * 0.05);
                },
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Items(
                    price: '100',
                    img:
                        'https://firebasestorage.googleapis.com/v0/b/oneupnoobs-9ee91.appspot.com/o/demoitem2.png?alt=media&token=090e999b-f570-465b-b6a5-fe322c3e9988',
                    onadd: () {},
                    ontap: () {},
                    subtitle: '7pcs, Price',
                    title: 'Organic Bananas',
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
}
