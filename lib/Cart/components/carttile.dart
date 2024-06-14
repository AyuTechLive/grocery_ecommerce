import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class CartTile extends StatelessWidget {
  const CartTile({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Container(
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
                  'https://firebasestorage.googleapis.com/v0/b/oneupnoobs-9ee91.appspot.com/o/demoitem2.png?alt=media&token=090e999b-f570-465b-b6a5-fe322c3e9988',
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
                  'Bell Pepper Red',
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
                  '1kg, Price',
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.clear,
                    color: Color(0xffB3B3B3),
                  )),
              SizedBox(
                height: height * 0.04,
              ),
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
              SizedBox(
                height: height * 0.04,
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
