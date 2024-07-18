import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Album/albumtile.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Album/photogallery.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class GalleryAlbum extends StatefulWidget {
  const GalleryAlbum({super.key});

  @override
  State<GalleryAlbum> createState() => _GalleryAlbumState();
}

class _GalleryAlbumState extends State<GalleryAlbum> {
  late Stream<QuerySnapshot> events;
  final CollectionReference gallerycollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'))
          .collection('Gallery');

  @override
  void initState() {
    super.initState();
    events = gallerycollection.snapshots();
  }

  Future<void> deleteAlbum(String albumName) async {
    try {
      await gallerycollection.doc(albumName).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Album deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete album: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Albums',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Expanded(child: notificationFetcher())
        ],
      ),
    );
  }

  Widget notificationFetcher() {
    final Size screensize = MediaQuery.of(context).size;
    final double width = screensize.width;
    return StreamBuilder(
      stream: events,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final albumData = snapshot.data!.docs[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: AlbumTile(
                  ontap: () {
                    nextScreen(
                      context,
                      PhotoGallery(
                        docid: albumData['Title'].toString(),
                      ),
                    );
                  },
                  albumName: albumData['Title'].toString(),
                  albumimg: albumData['GalleryImg'].toString(),
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Album"),
                          content: Text(
                              "Are you sure you want to delete this album?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () {
                                deleteAlbum(albumData['Title'].toString());
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
