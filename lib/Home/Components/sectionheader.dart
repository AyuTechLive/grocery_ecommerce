import 'package:flutter/material.dart';
import 'package:hakikat_app_new/ItemsShowing/Exclusiveitemshowing.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class Sectionheader extends StatelessWidget {
  final String title;
  final VoidCallback ontap;

  const Sectionheader({super.key, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Row(
      children: [
        SizedBox(
          width: width * 0.06,
        ),
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF181725),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        Spacer(),
        TextButton(
            onPressed: ontap,
            child: Text(
              'See all',
              style: TextStyle(
                color: Color(0xFF53B175),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            )),
        SizedBox(
          width: width * 0.02,
        )
      ],
    );
  }
}
