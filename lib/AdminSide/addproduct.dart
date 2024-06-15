import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool loading = false;
  final postcontroller = TextEditingController();
  late TextEditingController categorynamecontroller;
  final productitlecontroller = TextEditingController();
  final mapcontroller = TextEditingController();
  final productpricecontroller = TextEditingController();
  final matchimgcontroller = TextEditingController();
  final productsubtitlecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final timecontroller = TextEditingController();
  final prizepoolcontroller = TextEditingController();
  final productquantitycontroller = TextEditingController();
  final roomidcontroller = TextEditingController();
  final maxparticipantscontroller = TextEditingController();

  late DatabaseReference databaseRef;
  late FirebaseStorage storage;
  String? selectedCourse;
  List<String> courses = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  File? _image;
  bool isExclusive = false;
  bool isBestSelling = false;

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

  Future<void> handleImageUpload() async {
    if (_image != null) {
      try {
        String imageUrl = await uploadimage();
        matchimgcontroller.text =
            imageUrl; // Save the image URL to the controller
      } catch (e) {
        //  Utils().toastMessage('Failed to upload image: $e');
      }
    } else {
      //Utils().toastMessage('No image selected');
    }
  }

  @override
  void initState() {
    fetchCourses();
    // TODO: implement initState

    categorynamecontroller = TextEditingController();
    storage = FirebaseStorage.instance;
  }

  void fetchCourses() async {
    // Fetch courses from Firestore and update the local list
    var querySnapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    for (var doc in querySnapshot.docs) {
      courses.add(doc.id); // Assuming you use document IDs as course names
    }
    // If required, update the state to reflect the changes in the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenthemecolor,
        title: Text('Add New Match '),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xff001C65), width: 3),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.gamepad,
                        color: Color(0xff001C65)), // Icon on the left side
                    SizedBox(width: 10), // Space between icon and text
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: selectedCourse,
                          hint: Text('Select Category'),
                          items: courses.map((String course) {
                            return DropdownMenuItem<String>(
                              value: course,
                              child: Text(course),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            // Update the selected course state
                            setState(() {
                              selectedCourse = newValue;
                              categorynamecontroller.text =
                                  selectedCourse ?? '';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // DropdownButtonFormField<String>(
              //   value: selectedCourse,
              //   hint: Text('Select Game'),
              //   items: courses.map((String course) {
              //     return DropdownMenuItem<String>(
              //       value: course,
              //       child: Text(course),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {
              //     // Update the selected course state
              //     setState(() {
              //       selectedCourse = newValue;
              //       cousenamecontroller.text = selectedCourse ?? '';
              //     });
              //   },
              // ),
              // TextFormField(
              //   controller: cousenamecontroller,
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //       hintText: 'Enter the course name',
              //       border: OutlineInputBorder()),
              // ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                controller: productitlecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Product Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                controller: productsubtitlecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter Subtitle',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),

              TextFormField(
                controller: productpricecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Price Of Product',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              // InkWell(
              //   onTap: () => _selectDate(context),
              //   child: IgnorePointer(
              //     child: TextFormField(
              //       controller: datecontroller,
              //       maxLines: 1,
              //       decoration: InputDecoration(
              //         hintText: 'Match Date',
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(10)),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: height * 0.01,
              // ),
              // InkWell(
              //   onTap: () => _selectTime(context),
              //   child: IgnorePointer(
              //     child: TextFormField(
              //       controller: timecontroller,
              //       maxLines: 1,
              //       decoration: InputDecoration(
              //         hintText: 'Match Time',
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(10)),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: height * 0.01,
              // ),
              // TextFormField(
              //   controller: prizepoolcontroller,
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //       hintText: 'Enter Prizepool',
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10))),
              // ),
              // SizedBox(
              //   height: height * 0.01,
              // ),
              TextFormField(
                controller: productquantitycontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Quantity ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              // TextFormField(
              //   controller: roomidcontroller,
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //       hintText: 'Enter Room Id',
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10))),
              // ),
              // SizedBox(
              //   height: height * 0.01,
              // ),
              // TextFormField(
              //   controller: maxparticipantscontroller,
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //       hintText: 'Max Participants',
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10))),
              // ),
              // SizedBox(
              //   height: height * 0.01,
              // ),
              TextFormField(
                controller: matchimgcontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Your Image url',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    icon: InkWell(
                        onTap: () async {
                          await getimageGallery();
                          await handleImageUpload();
                        },
                        child: Icon(Icons.add))),
              ),
              SwitchListTile(
                title: Text('Exclusive'),
                value: isExclusive,
                onChanged: (value) {
                  setState(() {
                    isExclusive = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Best Selling'),
                value: isBestSelling,
                onChanged: (value) {
                  setState(() {
                    isBestSelling = value;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                loading: loading,
                title: 'Add PDF',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = postcontroller.text.toString();
                  String idnew =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef = FirebaseDatabase.instance.ref(id);

                  databaseRef

                      // inreplacement of videos action is used
                      .child(idnew)
                      .set({
                    'id': idnew,
                    'Product Title': productitlecontroller.text.toString(),
                    'Product Img': matchimgcontroller.text.toString(),
                    'Product Subtitle':
                        productsubtitlecontroller.text.toString(),
                    'Product Price': productpricecontroller.text.toString(),
                    'Product Stock': productquantitycontroller.text.toString(),
                    'Category': categorynamecontroller.text.toString(),
                    'Exclusive':
                        isExclusive, // Add the 'Exclusive' key-value pair
                    'BestSelling': isBestSelling,
                  }).then(
                    (value) {
                      Utils().toastMessage('Post Succesfully Added');
                      setState(() {
                        loading = false;
                        // productitlecontroller.clear();
                        // mapcontroller.clear();
                        // productpricecontroller.clear();
                        // matchimgcontroller.clear();
                        // productsubtitlecontroller.clear();
                      });
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        datecontroller.text = '${picked.year}-${picked.month}-${picked.day}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timecontroller.text = '${picked.hour}:${picked.minute}';
      });
    }
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
}
