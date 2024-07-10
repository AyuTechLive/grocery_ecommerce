import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakeekat_farmer_version/Gallery/albumtile.dart';
import 'package:hakeekat_farmer_version/Gallery/photogallery.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/widget.dart';

class GalleryAlbum extends StatefulWidget {
  const GalleryAlbum({super.key});

  @override
  State<GalleryAlbum> createState() => _GalleryAlbumState();
}

class _GalleryAlbumState extends State<GalleryAlbum> {
  late Stream<QuerySnapshot> events;
  final CollectionReference gallerycollection =
      FirebaseFirestore.instance.collection('Gallery');
  @override
  void initState() {
    super.initState();
    events = gallerycollection.snapshots();
    ;
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.greenthemecolor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: BackButton(),
        title: Text(
          'Albums',
          style: TextStyle(
            // color: Colors.white,
            fontSize: 16,
            fontFamily: 'Quando',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(child: notificationFetcher())
        ],
      ),
    );
  }

  Widget notificationFetcher() {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return StreamBuilder(
      stream: events,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // Sort the list of notifications based on timestamp
          // Assuming 'id' is the timestamp

          return ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                  child: AlbumTile(
                      ontap: () {
                        nextScreen(
                            context,
                            PhotoGallery(
                              docid: snapshot.data!.docs[index]['Title']
                                  .toString(),
                            ));
                      },
                      albumName: snapshot.data!.docs[index]['Title'].toString(),
                      albumimg:
                          snapshot.data!.docs[index]['GalleryImg'].toString()));

              // );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
