import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Cart/components/carttile.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
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
              'My Cart',
              textAlign: TextAlign.center,
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
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: height * 0.01,
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
                    )
                  ],
                );
              },
              itemCount: 2,
              itemBuilder: (context, index) {
                return CartTile();
              },
            ),
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
                'Go to Checkout',
                style: TextStyle(
                  color: Color(0xFFFCFCFC),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  height: 0.06,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          )
        ],
      ),
    );
  }
}
