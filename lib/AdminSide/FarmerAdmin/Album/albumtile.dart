import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlbumTile extends StatelessWidget {
  final String albumName;
  final String albumimg;
  final VoidCallback ontap;
  final VoidCallback onDelete;
  const AlbumTile({
    super.key,
    required this.albumName,
    required this.albumimg,
    required this.ontap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return TextButton(
      onPressed: ontap,
      child: Container(
        width: width * 0.9,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
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
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.04636,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
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
                      SizedBox(
                        height: height * 0.0075,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
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
