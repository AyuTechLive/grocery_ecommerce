import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddLecturesAdmin extends StatefulWidget {
  const AddLecturesAdmin({Key? key}) : super(key: key);

  @override
  State<AddLecturesAdmin> createState() => _AddLecturesAdminState();
}

class _AddLecturesAdminState extends State<AddLecturesAdmin> {
  bool loading = false;
  final postcontroller = TextEditingController();

  final subjectcontroller = TextEditingController();
  final videotitlecontroller = TextEditingController();
  final videosubtitlecontroller = TextEditingController();
  final videourlcontroller = TextEditingController();
  final videolectureno = TextEditingController();
  final secondFirebaseFirestore =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'));
  final secondFirebaseDatabase =
      FirebaseDatabase.instanceFor(app: Firebase.app('secondary'));
  late DatabaseReference databaseRef;
  String? selectedCourse;
  String? selectedSubject;
  List<String> courses = [];
  List<String> subjects = [];
  int counter = 0;
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage() async {
    if (_image == null) return '';

    final Reference storageRef =
        FirebaseStorage.instanceFor(app: Firebase.app('secondary'))
            .ref()
            .child('video_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final UploadTask uploadTask = storageRef.putFile(_image!);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
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
        title: Text('Add Your Content'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: videotitlecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter Your Video Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: videosubtitlecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter Your Video Subtitle',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: videourlcontroller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter Your video URL',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: height * 0.03),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: height * 0.02),
              _image != null
                  ? Image.file(_image!, height: 100)
                  : Text('No image selected'),
              SizedBox(height: height * 0.05),
              RoundButton(
                loading: loading,
                title: 'Add Video Lecture',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });

                  String imageUrl = await _uploadImage();

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef = secondFirebaseDatabase.ref('videos');
                  databaseRef.child(id).set({
                    'id': id,
                    'Title': videotitlecontroller.text.toString(),
                    'Subtitle': videosubtitlecontroller.text.toString(),
                    'Video Link': videourlcontroller.text.toString(),
                    'imageUrl': imageUrl
                  }).then(
                    (value) {
                      Utils().toastMessage('Post Successfully Added');
                      setState(() {
                        counter++;
                        loading = false;
                        subjectcontroller.clear();
                        videotitlecontroller.clear();
                        videosubtitlecontroller.clear();
                        videourlcontroller.clear();
                        videolectureno.clear();
                        _image = null;
                      });
                    },
                  ).catchError((error) {
                    Utils().toastMessage('Error: $error');
                    setState(() {
                      loading = false;
                    });
                  });
                },
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
