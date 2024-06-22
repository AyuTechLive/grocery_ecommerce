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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.25,
                height: width * 0.25,
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
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF181725),
                        fontSize: 16,
                        fontFamily: 'Gilroy-Bold',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.10,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 14,
                        fontFamily: 'Gilroy-Medium',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Quantity: '),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                            color: Color(0xFF181725),
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: onremove,
                      icon: Icon(
                        Icons.clear,
                        color: Color(0xffB3B3B3),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 20, right: 10),
                    child: Text(
                      '₹ ${price}',
                      style: TextStyle(
                        color: Color(0xFF181725),
                        fontSize: 18,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: width * 0.9,
          height: 1,
          color: Color(0xFFE2E2E2),
        ),
      ],
    );
  }
}
