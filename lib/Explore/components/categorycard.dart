import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String img;
  final String title;
  final Color color;
  final VoidCallback ontap;
  const CategoryCard(
      {super.key,
      required this.img,
      required this.title,
      required this.color,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width * 0.421,
        height: height * 0.211,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: color),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height * 0.1,
              child: Image.network(
                img,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 14,
                    fontFamily: 'Gilroy-Bold',
                    fontWeight: FontWeight.w600,
                    height: 1.5, // Increase the line spacing
                    letterSpacing: 0.10,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
