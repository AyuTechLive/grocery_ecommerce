import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class FavoriteTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String img;
  final VoidCallback ondelete;
  final VoidCallback ontap;
  const FavoriteTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.price,
      required this.img,
      required this.ondelete,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return IconButton(
      onPressed: ontap,
      icon: Column(
        children: [
          Container(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Column(
                  children: [
                    Container(
                      width: width * 0.2,
                      height: width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          img,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.330,
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Color(0xFF181725),
                              fontSize: 16,
                              fontFamily: 'Gilroy-Bold',
                              fontWeight: FontWeight.w400,
                              //  height: 0.07,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.2,
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14,
                              fontFamily: 'Gilroy-Medium',
                              fontWeight: FontWeight.w400,
                              //   height: 0.09,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
                Spacer(),
                Spacer(),
                Spacer(),
                Column(
                  children: [
                    // IconButton(
                    //     onPressed: ondelete,
                    //     icon: Icon(
                    //       Icons.clear,
                    //       color: Color(0xffB3B3B3),
                    //     )),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      children: [
                        Text(
                          '₹ ${price}  ',
                          style: TextStyle(
                            color: Color(0xFF181725),
                            fontSize: 18,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                            height: 0.08,
                            letterSpacing: 0.10,
                          ),
                        ),
                        Icon(
                          Icons.expand_more,
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.007,
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
        ],
      ),
    );
  }
}
