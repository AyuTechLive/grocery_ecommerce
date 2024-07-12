import 'package:flutter/material.dart';

class AccountMenuCard extends StatelessWidget {
  final String title;
  final String img;
  final VoidCallback ontap;
  const AccountMenuCard(
      {super.key, required this.title, required this.img, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return IconButton(
      onPressed: ontap,
      icon: Row(
        children: [
          SizedBox(
            width: width * 0.05,
          ),
          ImageIcon(AssetImage('assets/${img}.png')),
          SizedBox(
            width: width * 0.04,
          ),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF181725),
              fontSize: 15,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          Spacer(),
          ImageIcon(AssetImage('assets/backarrow.png')),
          SizedBox(
            width: width * 0.04,
          )
        ],
      ),
    );
  }
}
