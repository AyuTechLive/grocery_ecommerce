import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class OrderSucess extends StatelessWidget {
  const OrderSucess({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/ordersucess.png'),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Order has been\n placed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 28,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Text(
              'Your items has been placed and is on \nit’s way to being processed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 16,
                fontFamily: 'Gilroy-Medium',
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ));
                },
                icon: Text(
                  'Back to home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
                )),
            SizedBox(
              height: height * 0.02,
            )
          ],
        ),
      ),
    );
  }
}
