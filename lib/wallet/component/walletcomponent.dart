import 'package:flutter/material.dart';

class WalletComponent extends StatelessWidget {
  final String balance;
  final String reward;
  final String uid;
  final String name;
  const WalletComponent(
      {super.key,
      required this.balance,
      required this.reward,
      required this.uid,
      required this.name});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Container(
      width: width * 0.9,
      height: height * 0.25,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0xFF253939),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x2D253939),
            blurRadius: 60.42,
            offset: Offset(0, 6.04),
            spreadRadius: 15.11,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 212.98,
            top: -18.13,
            child: Container(
              width: 391.22,
              height: 391.22,
              decoration: ShapeDecoration(
                color: Color(0xFF273E3E),
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 252.26,
            top: 87.61,
            child: Container(
              width: 342.89,
              height: 342.89,
              decoration: ShapeDecoration(
                color: Color(0xFF2F5050),
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 373.10,
            top: 220.54,
            child: Container(
              width: 49.05,
              height: 39.15,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 49.05,
                      height: 39.15,
                      child: Stack(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: width * 0.053,
            top: height * 0.04,
            child: Opacity(
              opacity: 0.90,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.16,
                  letterSpacing: -0.15,
                ),
              ),
            ),
          ),
          Positioned(
            left: width * 0.053,
            top: height * 0.08,
            child: Opacity(
              opacity: 0.90,
              child: Text(
                'Total Balance : ${balance}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.16,
                  letterSpacing: -0.15,
                ),
              ),
            ),
          ),
          Positioned(
            left: width * 0.053,
            top: height * 0.12,
            child: Opacity(
              opacity: 0.90,
              child: Text(
                'Bonus Amount : ${reward}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.16,
                  letterSpacing: -0.15,
                ),
              ),
            ),
          ),
          Positioned(
            left: width * 0.053,
            top: height * 0.22,
            child: Opacity(
              opacity: 0.90,
              child: Text(
                '${uid}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.16,
                  letterSpacing: -0.15,
                ),
              ),
            ),
          ),
          Positioned(
            right: width * 0.053,
            top: height * 0.20,
            child: Opacity(
                opacity: 0.90,
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/hakkikatdemo.appspot.com/o/360_F_268723428_HWt44tSubXLRZwYmLTgiSNELsR5uCyEK-removebg-preview.png?alt=media&token=0a5081ea-962e-4eb7-aba2-2be9e6d0164c',
                  scale: 10,
                )),
          ),
        ],
      ),
    );
  }
}
