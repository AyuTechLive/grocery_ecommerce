import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Gallery/imageopeningpage.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';

class PhotoGallery extends StatefulWidget {
  final String docid;
  const PhotoGallery({super.key, required this.docid});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final CollectionReference gallerycollection =
      FirebaseFirestore.instance.collection('Gallery');
  late Stream<QuerySnapshot> gallery;
  @override
  void initState() {
    super.initState();
    gallery = gallerycollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    // Dummy data for the grid items
    List<Widget> items = List.generate(
        10, // Number of items in the grid
        (index) => Container(
              width: width * 0.402,
              height: height * 0.203,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/145x163"),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ));

    // Using GridView.builder to build the photo gallery grid
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Photo Gallery',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: notificationFetcher());
  }

  Widget notificationFetcher() {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return StreamBuilder(
      stream: gallery,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a circular progress indicator while waiting for data
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Handle error state
          return Center(
            child: Text('Error loading data'),
          );
        } else if (snapshot.hasData) {
          List<String> imageUrls = [];
          for (var doc in snapshot.data!.docs) {
            if (doc.id == widget.docid) {
              // Fetch image URLs from the document with the specified ID
              var images = List.from(doc['Images']);
              imageUrls.addAll(images.map((img) => img.toString()));
              break; // Exit the loop once the document is found
            }
          }
          // Display the grid once data is available
          return Padding(
            padding: EdgeInsets.only(
                left: width * 0.06, right: width * 0.06, top: height * 0.015),
            child: GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing:
                    width * 0.0416, // Space between items horizontally
                mainAxisSpacing:
                    height * 0.0275, // Space between items vertically
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                // Returning each item for the grid
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageOpeningPage(imgurl: imageUrls[index]),
                        ));
                  },
                  child: Container(
                    width: width * 0.402,
                    height: height * 0.30,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrls[index]),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 0.5, color: Color(0xFF0A1E51)),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          // Handle the case where there is no data
          return Container();
        }
      },
    );
  }
}
