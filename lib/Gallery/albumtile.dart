import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlbumTile extends StatelessWidget {
  final String albumName;
  final String albumimg;
  final VoidCallback ontap;
  const AlbumTile(
      {super.key,
      required this.albumName,
      required this.albumimg,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return TextButton(
      onPressed: ontap,
      child: Container(
        width: width * 0.9,
        // height: height * 0.2,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            // side: BorderSide(width: 1, color: Color(0xFF7455F7)),
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: width * 0.0333,
                ),
                CircleAvatar(
                  radius: height * 0.0375,
                  child: ClipOval(
                    child: Image.network(
                      albumimg,
                      fit: BoxFit.cover,
                      width: 60, // Adjust the width and height of the image
                      height: 60,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.04636,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.01125),
                      child: Container(
                        width: width * 0.59722,
                        // height: height * 0.04625,
                        decoration: ShapeDecoration(
                          color: Color(0x8C9EC0FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.01666,
                              height * 0.01, width * 0.075, height * 0.01),
                          child: Text(
                            albumName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Salsa',
                              fontWeight: FontWeight.w900,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.0075,
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'DATE: ',
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 14,
                    //         fontFamily: 'Poppins',
                    //         fontWeight: FontWeight.w600,
                    //         height: 0,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: height * 0.03,
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: height * 0.01,
                    ),

                    // SizedBox(
                    //   height: height * 0.01,
                    // ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
          ]),
        ),
      ),
    );
  }
}
