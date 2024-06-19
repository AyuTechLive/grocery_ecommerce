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
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool loading = false;
  final postController = TextEditingController();
  late TextEditingController categoryNameController;
  final productTitleController = TextEditingController();
  final mapController = TextEditingController();
  final productPriceController = TextEditingController();
  final productSubtitleController = TextEditingController();
  final productQuantityController = TextEditingController();
  final matchImgController = TextEditingController();
  bool isExclusive = false;
  bool isBestSelling = false;

  late DatabaseReference databaseRef;
  late FirebaseStorage storage;
  String? selectedCourse;
  List<String> courses = [];
  List<File> _images = []; // List to store image files
  List<String> _imageUrls = []; // List to store image URLs

  final picker = ImagePicker();

  Future<void> getImageGallery() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      });
    }
  }

  Future<void> handleImageUpload() async {
    if (_images.isNotEmpty) {
      try {
        List<String> uploadedUrls = await Future.wait(_images.map(uploadimage));
        setState(() {
          _imageUrls.addAll(uploadedUrls);
        });
      } catch (e) {
        Utils().toastMessage('Failed to upload images: $e');
      }
    } else {
      Utils().toastMessage('No images selected');
    }
  }

  @override
  void initState() {
    fetchCourses();
    categoryNameController = TextEditingController();
    storage = FirebaseStorage.instance;
    super.initState();
  }

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void fetchCourses() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    for (var doc in querySnapshot.docs) {
      // Access the 'Category name' field of the document
      var categoryName = doc['Category Name'];
      courses.add(categoryName);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.greenthemecolor,
        title: Text('Add New Product '),
        // foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
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
                              categoryNameController.text =
                                  selectedCourse ?? '';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                controller: productTitleController,
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
                controller: productSubtitleController,
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
                controller: productPriceController,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Price Of Product',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                controller: productQuantityController,
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
              //   controller: matchImgController,
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //     hintText: 'Enter Your Image url',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     icon: InkWell(
              //       onTap: () async {
              //         await getImageGallery();
              //       },
              //       child: Icon(Icons.add),
              //     ),
              //   ),
              // ),
              SizedBox(height: 10),
              SizedBox(
                height: height * 0.25,
                child: ListView.builder(
                  itemCount: _images.length + 1,
                  scrollDirection: Axis.horizontal,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 3,
                  //   mainAxisSpacing: 8,
                  //   crossAxisSpacing: 8,
                  // ),
                  itemBuilder: (context, index) {
                    if (index == _images.length) {
                      return IconButton(
                        onPressed: () async {
                          await getImageGallery();
                        },
                        icon: Container(
                          width: width * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Icon(Icons.add),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: width * 0.27,
                                      child:
                                          Center(child: Text('Add Images '))),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Container(
                          width: width * 0.4,
                          height: height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.file(
                            _images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                removeImage(index);
                              });
                            },
                          ),
                        ),
                      ],
                    );

                    // Stack(
                    //   children: [
                    //     Image.file(
                    //       _images[index],
                    //       fit: BoxFit.cover,
                    //     ),
                    //     Positioned(
                    //       top: 0,
                    //       right: 0,
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           removeImage(index);
                    //         },
                    //         child: Container(
                    //           color: Colors.black,
                    //           child: Icon(
                    //             Icons.clear,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // );
                  },
                ),
              )
              // : SizedBox.shrink(),
              ,
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
              SizedBox(height: 30),
              RoundButton(
                loading: loading,
                title: 'Add Product',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });

                  // First upload the images
                  await handleImageUpload();

                  String idnew =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef = FirebaseDatabase.instance.ref();

                  databaseRef.child(idnew).set({
                    'id': idnew,
                    'Product Title': productTitleController.text.toString(),
                    'Product Img': _imageUrls, // Store the list of image URLs
                    'Product Subtitle':
                        productSubtitleController.text.toString(),
                    'Product Price': productPriceController.text.toString(),
                    'Product Stock': productQuantityController.text.toString(),
                    'Category': categoryNameController.text.toString(),
                    'Exclusive': isExclusive,
                    'BestSelling': isBestSelling,
                  }).then(
                    (value) {
                      Utils().toastMessage('Post Successfully Added');
                      setState(() {
                        loading = false;
                      });
                    },
                  ).catchError((error) {
                    Utils().toastMessage('Failed to add post: $error');
                    setState(() {
                      loading = false;
                    });
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadimage(File imageFile) async {
    String fileExtension = imageFile.path.split('.').last;
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.$fileExtension';
    firebase_storage.Reference ref = storage.ref('/foldername/$fileName');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(
      contentType: 'image/$fileExtension',
      contentDisposition: 'inline; filename="$fileName"',
    );
    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile, metadata);
    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
