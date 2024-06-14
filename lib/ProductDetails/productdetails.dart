import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F3F2),
      ),
      body: Column(
        children: [
          Container(
            width: width,
            height: height * 0.31,
            decoration: ShapeDecoration(
              color: Color(0xFFF2F3F2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
            child: Center(
              child: SizedBox(
                width: width * 0.69,
                height: height * 0.21,
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/oneupnoobs-9ee91.appspot.com/o/Vector.png?alt=media&token=bce591e1-fb44-4596-b3ba-f5b739a8d9c1',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Spacer(),
              SizedBox(
                width: width * 0.604,
                child: Text(
                  'Naturel Red Apple',
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 20,
                    fontFamily: 'Gilroy-Bold',
                    fontWeight: FontWeight.w400,
                    //letterSpacing: 0.10,
                  ),
                ),
              ),
              Spacer(),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: ImageIcon(AssetImage('assets/wishlist.png')),
              ),
              Spacer()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.1,
              ),
              Text(
                '1kg, Price',
                style: TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  //height: 0.07,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Row(
            children: [
              Spacer(),
              Container(
                width: width * 0.11,
                height: height * 0.050,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFF0F0F0)),
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.remove),
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Text(
                '1',
                style: TextStyle(
                  color: Color(0xFF181725),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  height: 0.07,
                  letterSpacing: 0.10,
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Container(
                width: width * 0.11,
                height: height * 0.050,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFF0F0F0)),
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: AppColors.greenthemecolor,
                  ),
                ),
              ),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Text(
                '\$4.99',
                style: TextStyle(
                  color: Color(0xFF181725),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  height: 0.08,
                  letterSpacing: 0.10,
                ),
              ),
              Spacer()
            ],
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Container(
            width: width * (0.876),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE2E2E2),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.08,
              ),
              Text(
                'Product Detail',
                style: TextStyle(
                  color: Color(0xFF181725),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.expand_more)),
              SizedBox(
                width: width * 0.05,
              )
            ],
          ),
          SizedBox(
            width: width * 0.864,
            child: Text(
              'Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.',
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 13,
                fontFamily: 'Gilroy-Medium',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Container(
            width: width * (0.876),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE2E2E2),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Container(
            width: width * 0.879,
            height: height * 0.074,
            decoration: ShapeDecoration(
              color: AppColors.greenthemecolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19),
              ),
            ),
            child: Center(
              child: Text(
                'Add To Cart',
                style: TextStyle(
                  color: Color(0xFFFCFCFC),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  height: 0.06,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
