import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventsTile extends StatelessWidget {
  final String eventname;
  final String hostname;
  final String time;
  final String date;
  final String img;
  final VoidCallback ontap;
  const EventsTile(
      {super.key,
      required this.eventname,
      required this.hostname,
      required this.time,
      required this.date,
      required this.img,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width * 0.8888,
        //height: height * 0.3075,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)),
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Container(
                // width: width * 0.8833,
                height: height * 0.23,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(img),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.01, height * 0.0125, 0, height * 0.0125),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          eventname,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Sahitya',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        'HOST : ${hostname}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          // fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        'TIME - ${time}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          // fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: width * 0.1,
                // ),
                Spacer(),
                Column(
                  children: [
                    Image.asset('assets/eventimg.png'),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        // fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
