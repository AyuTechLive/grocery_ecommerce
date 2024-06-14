import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/Explore/components/categorycard.dart';
import 'package:hakikat_app_new/ItemsShowing/CategoryProducts.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

List<Color> colors = [Color(0xFF181725), Color(0x19F8A44C)];

class _ExploreState extends State<Explore> {
  final searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
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
          ]),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(width * 0.06),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing:
                    width * 0.03, // Space between items horizontally
                mainAxisSpacing: height * 0.019,
                crossAxisCount: 2,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return CategoryCard(
                  ontap: () {
                    nextScreen(context, CategoryProduct());
                  },
                  color: Color(0x19F8A44C),
                  img: '',
                  title: '',
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
