import 'package:flutter/material.dart';

class HomeCategoryItems extends StatelessWidget {
  final String img;
  final String title;
  final VoidCallback ontap;
  const HomeCategoryItems(
      {super.key, required this.img, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width * 0.599,
        height: height * 0.117,
        decoration: ShapeDecoration(
          color: Color(0xFFF8A44C).withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: width * 0.02),
            Container(
              width: width * 0.23,
              height: height * 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  img,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: width * 0.02),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF3E423F),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: width * 0.02),
          ],
        ),
      ),
    );
  }
}
