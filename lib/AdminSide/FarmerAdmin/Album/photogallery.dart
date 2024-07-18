import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PhotoGallery extends StatefulWidget {
  final String docid;
  const PhotoGallery({super.key, required this.docid});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final CollectionReference gallerycollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'))
          .collection('Gallery');
  late Stream<QuerySnapshot> gallery;

  @override
  void initState() {
    super.initState();
    gallery = gallerycollection.snapshots();
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      DocumentReference docRef = gallerycollection.doc(widget.docid);
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        List<dynamic> images = List.from(docSnapshot['Images']);
        images.remove(imageUrl);
        await docRef.update({'Images': images});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image deleted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Photo Gallery',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: notificationFetcher(),
    );
  }

  Widget notificationFetcher() {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return StreamBuilder(
      stream: gallery,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else if (snapshot.hasData) {
          List<String> imageUrls = [];
          for (var doc in snapshot.data!.docs) {
            if (doc.id == widget.docid) {
              var images = List.from(doc['Images']);
              imageUrls.addAll(images.map((img) => img.toString()));
              break;
            }
          }
          return Padding(
            padding: EdgeInsets.only(
                left: width * 0.06, right: width * 0.06, top: height * 0.015),
            child: GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: width * 0.0416,
                mainAxisSpacing: height * 0.0275,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle image tap if needed
                      },
                      child: Container(
                        width: width * 0.402,
                        height: height * 0.30,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrls[index]),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.5, color: Color(0xFF0A1E51)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Image"),
                                content: Text(
                                    "Are you sure you want to delete this image?"),
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
                                      deleteImage(imageUrls[index]);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
