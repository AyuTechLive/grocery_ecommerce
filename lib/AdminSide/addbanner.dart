import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddBanner extends StatefulWidget {
  const AddBanner({Key? key}) : super(key: key);

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  bool loading = false;
  bool isImageUploading = false;
  final bannerTitleController = TextEditingController();
  final bannerImageLinkController = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection('Banners');
  File? _image;
  Uint8List? _webImage; // For web platform
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        // For web platform
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _image = null;
        });
      } else {
        // For mobile platforms
        setState(() {
          _image = File(pickedFile.path);
          _webImage = null;
        });
      }
    } else {
      Utils().toastMessage('No image picked');
    }
  }

  Future<void> handleImageUpload() async {
    if (_image != null || _webImage != null) {
      try {
        setState(() {
          isImageUploading = true;
        });
        String imageUrl = await uploadImage();
        bannerImageLinkController.text = imageUrl;
      } catch (e) {
        Utils().toastMessage('Failed to upload image: $e');
      } finally {
        setState(() {
          isImageUploading = false;
        });
      }
    } else {
      Utils().toastMessage('No image selected');
    }
  }

  Widget _buildImageContainer() {
    if (kIsWeb && _webImage != null) {
      // For web platform
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          _webImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (!kIsWeb && _image != null) {
      // For mobile platforms
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          _image!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else {
      // No image selected
      return Icon(Icons.add_a_photo, size: 50, color: Colors.grey);
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
                if (_image != null || _webImage != null) {
                  await handleImageUpload();
                }
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildImageContainer(),
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
              loading: loading || isImageUploading,
              title: 'Upload Banner',
              onTap: () async {
                if (isImageUploading) {
                  Utils().toastMessage(
                      'Please wait for the image to finish uploading');
                  return;
                }

                if (bannerTitleController.text.isEmpty ||
                    bannerImageLinkController.text.isEmpty) {
                  Utils().toastMessage('Please fill all fields');
                  return;
                }

                setState(() {
                  loading = true;
                });

                try {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  await fireStore.doc(id).set({
                    'Banner Title': bannerTitleController.text.trim(),
                    'Banner Image Link': bannerImageLinkController.text.trim(),
                    'id': id,
                  });
                  Utils().toastMessage('Banner uploaded successfully');
                  Navigator.pop(context);
                } catch (error) {
                  Utils().toastMessage('Error uploading banner: $error');
                } finally {
                  setState(() {
                    loading = false;
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<String> uploadImage() async {
    if (_image == null && _webImage == null) {
      throw Exception('No image file selected');
    }

    String fileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    firebase_storage.Reference ref = storage.ref('/banners/$fileName');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
      contentDisposition: 'inline; filename="$fileName"',
    );

    firebase_storage.UploadTask uploadTask;

    if (kIsWeb) {
      // For web platform
      uploadTask = ref.putData(_webImage!, metadata);
    } else {
      // For mobile platforms
      uploadTask = ref.putFile(_image!, metadata);
    }

    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
