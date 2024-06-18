import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class Items extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String img;
  final VoidCallback ontap;
  final VoidCallback onadd;
  const Items(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.ontap,
      required this.onadd,
      required this.img,
      required this.price});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width * 0.4186,
        //height: height * 0.277,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFE2E2E2)),
            borderRadius: BorderRadius.circular(18),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x00000000),
              blurRadius: 12,
              offset: Offset(0, 6),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * (0.028)),
            Container(
              width: width * 0.241,
              height: height * 0.086,
              child: Image.network(
                img,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 16,
                    fontFamily: 'Gilroy-Bold',
                    fontWeight: FontWeight.w600,
                    height: 0.07,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.030,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.04),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 14,
                    fontFamily: 'Gilroy-Medium',
                    fontWeight: FontWeight.w400,
                    height: 0.09,
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '₹ ${price}',
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                    letterSpacing: 0.10,
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: onadd,
                    icon: Container(
                      width: width * 0.1103,
                      height: height * 0.050,
                      decoration: ShapeDecoration(
                        color: AppColors.greenthemecolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )),
                Spacer(),
                // Container(
                //   width: width * 0.1103,
                //   height: height * 0.050,
                //   decoration: ShapeDecoration(
                //     color: Color(0xFF53B175),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(17),
                //     ),
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
