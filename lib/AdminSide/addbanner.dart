import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddBanner extends StatefulWidget {
  const AddBanner({super.key});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  bool loading = false;
  final coursediscriptioncontroller = TextEditingController();
  final coursenamecontroller = TextEditingController();
  final coursepricecontroller = TextEditingController();
  final courseimglinkcontroller = TextEditingController();
  final bannerfunctioncontroller = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection('Banners');
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
        Utils().toastMessage('No image picked');
      }
    });
  }

  Future<void> handleImageUpload() async {
    if (_image != null) {
      try {
        String imageUrl = await uploadimage();
        courseimglinkcontroller.text =
            imageUrl; // Save the image URL to the controller
      } catch (e) {
        Utils().toastMessage('Failed to upload image: $e');
      }
    } else {
      Utils().toastMessage('No image selected');
    }
  }

  String _selectedItem = 'Course Function'; // Default selected item

  List<String> _dropdownItems = ['Course Function', 'External Link', 'Nothing'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Banner Data'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              DropdownButton<String>(
                value: _selectedItem,
                items: _dropdownItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: coursenamecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Banner Title', border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: bannerfunctioncontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Banner Function', border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: courseimglinkcontroller,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: 'Course Banner Img Link',
                    icon: InkWell(
                      child: Icon(Icons.add_a_photo),
                      onTap: () async {
                        await getimageGallery();
                        await handleImageUpload();
                      },
                    ),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                loading: loading,
                title: 'Next',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = coursenamecontroller.text.toString();
                  //String id = 'ayushshahi96kmr@gmail.com';
                  fireStore.doc(id).set({
                    'Course Name': coursenamecontroller.text.toString(),
                    'Course Img Link': courseimglinkcontroller.text.toString(),
                    'Banner Function': bannerfunctioncontroller.text.toString(),
                    'Banner Type': _selectedItem.toString(),
                    'id': id,
                  }).then(
                    (value) {
                      Utils().toastMessage('Banner Uploaded SucessFully');
                      setState(() {
                        loading = false;
                      });
                    },
                  ).onError(
                    (error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
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
