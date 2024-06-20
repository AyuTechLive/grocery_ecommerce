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
  final bannerTitleController = TextEditingController();
  final bannerImageLinkController = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection('Banners');
  File? _image;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils().toastMessage('No image picked');
      }
    });
  }

  Future<void> handleImageUpload() async {
    if (_image != null) {
      try {
        String imageUrl = await uploadImage();
        bannerImageLinkController.text = imageUrl;
      } catch (e) {
        Utils().toastMessage('Failed to upload image: $e');
      }
    } else {
      Utils().toastMessage('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Banner'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: bannerTitleController,
              decoration: InputDecoration(
                labelText: 'Banner Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await getImageFromGallery();
                if (_image != null) {
                  await handleImageUpload();
                }
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: bannerImageLinkController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Banner Image Link',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            SizedBox(height: 30),
            RoundButton(
              loading: loading,
              title: 'Upload Banner',
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'Banner Title': bannerTitleController.text.trim(),
                  'Banner Image Link': bannerImageLinkController.text.trim(),
                  'id': id,
                }).then(
                  (value) {
                    Utils().toastMessage('Banner uploaded successfully');
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
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
    );
  }

  Future<String> uploadImage() async {
    if (_image == null) {
      throw Exception('No image file selected');
    }
    String fileExtension = _image!.path.split('.').last;
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.$fileExtension';
    firebase_storage.Reference ref = storage.ref('/banners/$fileName');
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
