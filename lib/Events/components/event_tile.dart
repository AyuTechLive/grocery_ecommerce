import 'package:flutter/material.dart';

import 'package:hakikat_app_new/Utils/colors.dart';

class EventsTile extends StatelessWidget {
  final String eventname;
  final String hostname;
  final String time;
  final String date;
  final String img;
  final VoidCallback ontap;

  const EventsTile({
    Key? key,
    required this.eventname,
    required this.hostname,
    required this.time,
    required this.date,
    required this.img,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width * 0.9,
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                img,
                height: height * 0.25,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventname,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(Icons.person, 'Host: $hostname'),
                            SizedBox(height: height * 0.005),
                            _buildInfoRow(Icons.access_time, time),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.event,
                              size: 30, color: AppColors.greenthemecolor),
                          SizedBox(height: height * 0.005),
                          Text(
                            date,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.greenthemecolor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
