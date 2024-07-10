import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/AddAlbum.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddGalleryImages extends StatefulWidget {
  const AddGalleryImages({super.key});

  @override
  State<AddGalleryImages> createState() => _AddGalleryImagesState();
}

class _AddGalleryImagesState extends State<AddGalleryImages> {
  bool loading = false;
  final fireStore =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'))
          .collection('albums');
  final CollectionReference gallerycollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'))
          .collection('Gallery');
  String? selectedposition;
  List<String> positions = [];
  final hostnamecontroller = TextEditingController();
  final galleryimgcontroller = TextEditingController();
  final timecontroller = TextEditingController();
  late TextEditingController gallerynamecontroller;
  final datecontroller = TextEditingController();
  final dobcontroller = TextEditingController();

  File? _image;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();
  Future<void> getimageGallery() async {
    final pickedfile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      if (pickedfile != null) {
        _image = File(pickedfile.path);
      } else {
        // Utils().toastMessage('No image picked');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPosition();
    gallerynamecontroller = TextEditingController();
  }

  Future<void> handleImageUpload() async {
    if (_image != null) {
      try {
        String imageUrl = await uploadimage();
        galleryimgcontroller.text =
            imageUrl; // Save the image URL to the controller
      } catch (e) {
        //  Utils().toastMessage('Failed to upload image: $e');
      }
    } else {
      //Utils().toastMessage('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Add Gallery Image'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xff001C65), width: 3),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.class_outlined,
                        color: Color(0xff001C65)), // Icon on the left side
                    SizedBox(width: 10), // Space between icon and text
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: selectedposition,
                          hint: Text('Select Album'),
                          decoration: InputDecoration(
                            enabledBorder:
                                InputBorder.none, // Removes underline
                          ),
                          onChanged: (newValue) {
                            // Update the selected course state
                            setState(() {
                              selectedposition = newValue;
                              gallerynamecontroller.text =
                                  selectedposition ?? '';
                              // if (selectedCourse != null) {
                              //   fetchSubjects(selectedCourse!);
                              // }
                            });
                          },
                          items: positions.map((String course) {
                            return DropdownMenuItem<String>(
                              value: course,
                              child: Text(course),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select a Album';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        nextScreen(context, AddAlbum());
                      },
                      child: Text(
                        'Add Album',
                        style: TextStyle(
                            color: AppColors.greenthemecolor,
                            fontWeight: FontWeight.w700),
                      )),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),

              // TextFormField(
              //   controller: gallerynamecontroller,
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //       hintText: 'Title', border: OutlineInputBorder()),
              // ),
              TextFormField(
                controller: galleryimgcontroller,
                maxLines: 2,
                decoration: InputDecoration(
                    hintText: 'Select Gallery Pic',
                    icon: InkWell(
                      child: Icon(Icons.add_a_photo),
                      onTap: () async {
                        await getimageGallery();
                        await handleImageUpload();
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              RoundButton(
                loading: loading,
                title: 'Next',
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  addegalleryimages(
                    gallerynamecontroller.text.toString(),
                    galleryimgcontroller.text.toString(),
                  ).then(
                    (value) {
                      Utils().toastMessage('Details Sucessfully Added');
                      setState(() {
                        loading = false;
                      });
                      // nextScreenReplace(context, PhotoGallery());

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           AddCourseContentAfterAddingCourse(
                      //               coursename:
                      //                   coursenamecontroller.text.toString()),
                      //     ));
                    },
                  ).onError(
                    (error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                  );
                  //String id = 'ayushshahi96kmr@gmail.com';
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadimage() async {
    if (_image == null) {
      throw Exception('No image file selected');
    }
    String fileExtension = _image!.path.split('.').last;
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.$fileExtension';
    firebase_storage.Reference ref = storage.ref('/foldername/$fileName');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(
      contentType: 'image/$fileExtension',
      contentDisposition: 'inline; filename="$fileName"',
    );
    firebase_storage.UploadTask uploadTask = ref.putFile(_image!, metadata);
    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  void fetchPosition() async {
    // Fetch courses from Firestore and update the local list
    var querySnapshot =
        await FirebaseFirestore.instanceFor(app: Firebase.app('secondary'))
            .collection('albums')
            .get();
    for (var doc in querySnapshot.docs) {
      positions.add(doc.id); // Assuming you use document IDs as course names
    }
    // If required, update the state to reflect the changes in the UI
    setState(() {});
  }

  Future<void> addegalleryimages(String title, String eventbannerimg) async {
    var date = DateTime.now().microsecondsSinceEpoch.toString();
    // Get the current document reference
    DocumentReference docRef = gallerycollection.doc(title);

    // Retrieve the current document data
    DocumentSnapshot docSnapshot = await docRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Retrieve the current list of images
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      List<dynamic> images = data['Images'] ?? [];

      // Add the new image URL to the list of images
      images.add(eventbannerimg);

      // Update the document with the updated list of images
      await docRef.update({
        'Images': images,
        'Title': title,
        'id': date,
      });
    } else {
      // If the document does not exist, create a new one with the image URL
      await gallerycollection.doc(title).set({
        'GalleryImg': eventbannerimg,
        'Images': [eventbannerimg],
        'Title': title,
        'id': date,
      });
    }
  }
}
