import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class CartTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final int quantity;
  final String img;
  final VoidCallback onremove;
  const CartTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.price,
      required this.quantity,
      required this.img,
      required this.onremove});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Column(
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
                    width: width * 0.241,
                    height: height * 0.086,
                    child: Image.network(
                      img,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
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
                  SizedBox(
                    height: height * 0.005,
                  ),
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
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Text('Quantity: '),
                      // Container(
                      //   width: width * 0.11,
                      //   height: height * 0.050,
                      //   decoration: ShapeDecoration(
                      //     shape: RoundedRectangleBorder(
                      //       side: BorderSide(width: 1, color: Color(0xFFF0F0F0)),
                      //       borderRadius: BorderRadius.circular(17),
                      //     ),
                      //   ),
                      //   child: Center(
                      //     child: Icon(Icons.remove),
                      //   ),
                      // ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        quantity.toString(),
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
                      // Container(
                      //   width: width * 0.11,
                      //   height: height * 0.050,
                      //   decoration: ShapeDecoration(
                      //     shape: RoundedRectangleBorder(
                      //       side: BorderSide(width: 1, color: Color(0xFFF0F0F0)),
                      //       borderRadius: BorderRadius.circular(17),
                      //     ),
                      //   ),
                      //   child: Center(
                      //     child: Icon(
                      //       Icons.add,
                      //       color: AppColors.greenthemecolor,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
              Spacer(),
              Spacer(),
              Spacer(),
              Column(
                children: [
                  IconButton(
                      onPressed: onremove,
                      icon: Icon(
                        Icons.clear,
                        color: Color(0xffB3B3B3),
                      )),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Text(
                    '₹ ${price}',
                    style: TextStyle(
                      color: Color(0xFF181725),
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      height: 0.08,
                      letterSpacing: 0.10,
                    ),
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
          height: height * 0.005,
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
    );
  }
}
