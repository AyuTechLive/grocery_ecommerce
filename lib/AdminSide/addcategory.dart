import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection("Categories");
  bool loading = false;
  bool isImageUploading = false;
  final categoryNameController = TextEditingController();
  final categoryImageController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        handleImageUpload();
      }
    });
  }

  Future<void> handleImageUpload() async {
    if (_image != null) {
      try {
        setState(() {
          isImageUploading = true;
        });
        String imageUrl = await uploadImage();
        categoryImageController.text = imageUrl;
      } catch (e) {
        Utils().toastMessage('Failed to upload image: $e');
      } finally {
        setState(() {
          isImageUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Add New Category',
            style: TextStyle(fontWeight: FontWeight.w400)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Details',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(height: 24),
              _buildTextField(
                controller: categoryNameController,
                labelText: 'Category Name',
                hintText: 'Enter category name',
              ),
              SizedBox(height: 24),
              _buildImagePicker(),
              SizedBox(height: 36),
              _buildAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.greenthemecolor, width: 2),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Image',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: getImageFromGallery,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_image!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo,
                          size: 40, color: Colors.grey[400]),
                      SizedBox(height: 8),
                      Text(
                        'Tap to add image',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return RoundButton(
      title: 'Add Category',
      onTap: _addCategory,
      loading: loading || isImageUploading,
    );
  }

  void _addCategory() async {
    if (isImageUploading) {
      Utils().toastMessage('Please wait for the image to finish uploading');
      return;
    }

    if (categoryNameController.text.isEmpty ||
        categoryImageController.text.isEmpty) {
      Utils().toastMessage('Please fill all fields');
      return;
    }

    setState(() => loading = true);

    try {
      await addCategoryToFirestore(
        categoryNameController.text.trim(),
        categoryImageController.text.trim(),
      );
      Utils().toastMessage('Category successfully added');
      Navigator.pop(context);
    } catch (error) {
      Utils().toastMessage('Error adding category: $error');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<String> uploadImage() async {
    if (_image == null) throw Exception('No image file selected');

    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/categories/$fileName');

    await ref.putFile(_image!);
    return await ref.getDownloadURL();
  }

  Future<void> addCategoryToFirestore(
      String categoryName, String categoryImageUrl) async {
    await categoriesCollection.doc(categoryName).set({
      'Category Img': categoryImageUrl,
      'Category Name': categoryName,
    });
  }
}
