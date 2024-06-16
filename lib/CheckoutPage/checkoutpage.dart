import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.1,
              ),
              Text('Delivery address'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.85,
                height: height * 0.07532,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Icon(Icons.home_filled),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Home'), Text('N-1/8 GKA ')],
                    ),
                    Spacer(),
                    Icon(Icons.expand_more),
                    SizedBox(
                      width: width * 0.03,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: width * 0.85,
                  // height: height * 0.07532,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Text('Order Summary'),
                      Row(
                        children: [Text('Total Item'), Text('2')],
                      ),
                      Row(
                        children: [Text('Total Amount'), Text('2000')],
                      )
                    ],
                  )),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Container(
              width: width * 0.879,
              height: height * 0.074,
              decoration: ShapeDecoration(
                color: AppColors.greenthemecolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Spacer(),
                  Text(
                    'Place Order',
                    style: TextStyle(
                      color: Color(0xFFFCFCFC),
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      height: 0.06,
                    ),
                  ),
                  Spacer(),
                  Spacer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
